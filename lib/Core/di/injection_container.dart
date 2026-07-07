import 'package:dio/dio.dart';
import 'package:eshara/current_user_store.dart';
import 'package:eshara/features/Dictionary/domain/usecases/get_categories_usecase.dart';
import 'package:eshara/features/Dictionary/domain/usecases/get_words_usecase.dart';
import 'package:eshara/features/Dictionary/ui/bloc/dictionary_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:get_it/get_it.dart';

// Authentication
import 'package:eshara/features/Authentication/Data/datasources/auth_remote_datasource.dart';
import 'package:eshara/features/Authentication/Data/repositories/auth_repo_impl.dart';
import 'package:eshara/features/Authentication/domain/repositories/auth_repository.dart';
import 'package:eshara/features/Authentication/domain/usecases/login_usecase.dart';
import 'package:eshara/features/Authentication/domain/usecases/register_usecase.dart';
import 'package:eshara/features/Authentication/domain/usecases/resend_otp_usecase.dart';
import 'package:eshara/features/Authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:eshara/features/Authentication/ui/bloc/auth_bloc.dart';

// Add Word
import 'package:eshara/features/addword/Data/datasources/add_word_remote_datasource.dart';
import 'package:eshara/features/addword/Data/repositories/add_word_repository_impl.dart';
import 'package:eshara/features/addword/domain/repositories/add_word_repository.dart';
import 'package:eshara/features/addword/domain/usecases/submit_word_request_usecase.dart';
import 'package:eshara/features/addword/ui/bloc/add_word_bloc.dart';

// Dictionary
import 'package:eshara/features/Dictionary/Data/datasources/dictionary_remote_datasource.dart';
import 'package:eshara/features/Dictionary/Data/repositories/dictionary_repo_impl.dart';
import 'package:eshara/features/Dictionary/domain/repositories/dictionary_repository.dart';
import 'package:eshara/features/Dictionary/domain/usecases/search_signs_usecase.dart';

// Profile
import 'package:eshara/features/Profile/Data/datasources/profile_remote_datasource.dart';
import 'package:eshara/features/Profile/Data/repositories/profile_repo_impl.dart';
import 'package:eshara/features/Profile/domain/repositories/profile_repository.dart';
import 'package:eshara/features/Profile/domain/usecases/profile_usecases.dart';
import 'package:eshara/features/Profile/ui/bloc/profile_bloc.dart';

// SignToText
import 'package:eshara/features/SignToText/Data/datasources/sign_remote_datasource.dart';
import 'package:eshara/features/SignToText/Data/repositories/sign_repo_impl.dart';
import 'package:eshara/features/SignToText/domain/repositories/sign_repository.dart';
import 'package:eshara/features/SignToText/domain/usecases/translate_sign.dart';
import 'package:eshara/features/SignToText/ui/bloc/sign_bloc.dart';

// TextToSign
import 'package:eshara/features/Text_to_sign/Data/datasources/text_to_sign_datasource.dart';
import 'package:eshara/features/Text_to_sign/Data/repositories/text_to_sign_repo_impl.dart';
import 'package:eshara/features/Text_to_sign/domain/repositories/text_to_sign_repository.dart';
import 'package:eshara/features/Text_to_sign/domain/usecases/convert_text_to_sign.dart';
import 'package:eshara/features/Text_to_sign/ui/bloc/text_to_sign_bloc.dart';

// Admin
import 'package:eshara/features/admin/data/datasources/admin_remote_datasource.dart';
import 'package:eshara/features/admin/data/repositories/admin_repo_impl.dart';
import 'package:eshara/features/admin/domain/repositories/admin_repository.dart';
import 'package:eshara/features/admin/domain/usecases/admin_usecases.dart';
import 'package:eshara/features/admin/ui/bloc/admin_bloc.dart';

final sl = GetIt.instance;
bool _dependenciesInitialized = false;

Future<void> initDependencies() async {
  if (_dependenciesInitialized) return;
  _dependenciesInitialized = true;

  // ═════════════════════════════════════════════════════════════════
  // 0. Core / External (الأول لأن الكل بيحتاجهم)
  // ═════════════════════════════════════════════════════════════════

  // Shared Preferences
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
  await sl.isReady<SharedPreferences>();

  // http.Client
  sl.registerLazySingleton(() => http.Client());

  // ═════════════════════════════════════════════════════════════════
  // Dio الرئيسي للـ Eshara API
  // ═════════════════════════════════════════════════════════════════
sl.registerLazySingleton<Dio>(() {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://eshara.runasp.net',
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 30),
  ));

  // ✅ Auth Interceptor متقدم
  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      final token = CurrentUserStore.instance.getToken();
      
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
        print('🔑 Token attached: ${token.substring(0, 20)}...');
      } else {
        print('⚠️ No valid token - request will be unauthorized');
      }
      
      return handler.next(options);
    },
    onError: (DioException e, handler) {
      if (e.response?.statusCode == 401) {
        print('🔴 401 Unauthorized - Token expired!');
        
        // ✅ نعمل logout تلقائي
        CurrentUserStore.instance.clear();
        
        // ✅ نبعت event للـ AuthBloc
        // TODO: Use event bus or navigator
      }
      return handler.next(e);
    },
  ));

  // Log
  dio.interceptors.add(LogInterceptor(
    request: true,
    requestHeader: true,
    requestBody: true,
    responseHeader: true,
    responseBody: true,
    error: true,
  ));

  return dio;
});

  // ═════════════════════════════════════════════════════════════════
  // 1. Authentication
  // ═════════════════════════════════════════════════════════════════
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl<http.Client>(),
      sharedPreferences: sl<SharedPreferences>(),
      dio: sl<Dio>(),
    ),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl<AuthRepository>()));
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      verifyOtpUseCase: sl<VerifyOtpUseCase>(),
      resendOtpUseCase: sl<ResendOtpUseCase>(),
    ),
  );

  // ═════════════════════════════════════════════════════════════════
  // 2. Profile
  // ═════════════════════════════════════════════════════════════════
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () =>
        ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => GetProfileUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<ProfileRepository>()));
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: sl<GetProfileUseCase>(),
      updateProfileUseCase: sl<UpdateProfileUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );

  // ═════════════════════════════════════════════════════════════════
  // 3. Sign To Text
  // ═════════════════════════════════════════════════════════════════
  sl.registerLazySingleton<SignRemoteDataSource>(
    () => SignRemoteDataSourceImpl(client: sl<http.Client>(), dio: sl<Dio>()),
  );
  sl.registerLazySingleton<SignRepository>(
    () => SignRepositoryImpl(remoteDataSource: sl<SignRemoteDataSource>()),
  );
  sl.registerLazySingleton<TranslateSignUseCase>(
    () => TranslateSignUseCase(sl<SignRepository>()),
  );
  sl.registerFactory<SignBloc>(
    () => SignBloc(translateSignUseCase: sl<TranslateSignUseCase>()),
  );

  // ═════════════════════════════════════════════════════════════════
  // 4. Dictionary (✅ ترتيب صحيح)
  // ═════════════════════════════════════════════════════════════════

  // ═════════════════════════════════════════════════════════════════
  // 4. Dictionary
  // ═════════════════════════════════════════════════════════════════

  // 4.1 Data Layer
  sl.registerLazySingleton<DictionaryRemoteDataSource>(
    () => DictionaryRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<DictionaryRepository>(
    () => DictionaryRepositoryImpl(
      remoteDataSource: sl<DictionaryRemoteDataSource>(),
    ),
  );

  // 4.2 Use Cases (✅ كلهم من Dictionary domain)
  sl.registerLazySingleton(
    () => GetCategoriesUseCase(sl<DictionaryRepository>()),
  );
  sl.registerLazySingleton(
    () => GetWordsUseCase(sl<DictionaryRepository>()),
  );
  sl.registerLazySingleton(
    () => SearchSignsUseCase(sl<DictionaryRepository>()),
  );

  // 4.3 Bloc
  sl.registerFactory<DictionaryBloc>(
    () => DictionaryBloc(
      getCategoriesUseCase: sl<GetCategoriesUseCase>(),
      getWordsUseCase: sl<GetWordsUseCase>(),
      searchSignsUseCase: sl<SearchSignsUseCase>(),
    ),
  );

  // ═════════════════════════════════════════════════════════════════
  // 5. Add Word
  // ═════════════════════════════════════════════════════════════════
  sl.registerLazySingleton<AddWordRemoteDataSource>(
    () => AddWordRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AddWordRepository>(
    () =>
        AddWordRepositoryImpl(remoteDataSource: sl<AddWordRemoteDataSource>()),
  );
  sl.registerLazySingleton<SubmitWordRequestUseCase>(
    () => SubmitWordRequestUseCase(sl<AddWordRepository>()),
  );
  sl.registerFactory<AddWordBloc>(
    () => AddWordBloc(submitWordRequestUseCase: sl<SubmitWordRequestUseCase>()),
  );

  // ═════════════════════════════════════════════════════════════════
  // 6. Text To Sign (Avatar API)
  // ═════════════════════════════════════════════════════════════════
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://text-to-avatar-production.up.railway.app',
        headers: {'Content-Type': 'application/json'},
      ),
    );
    return dio;
  }, instanceName: 'avatarDio');

  sl.registerLazySingleton<TextToSignRemoteDataSource>(
    () =>
        TextToSignRemoteDataSourceImpl(dio: sl<Dio>(instanceName: 'avatarDio')),
  );
  sl.registerLazySingleton<TextToSignRepository>(
    () => TextToSignRepositoryImpl(
      remoteDataSource: sl<TextToSignRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton(
    () => ConvertTextToSignUseCase(sl<TextToSignRepository>()),
  );
  sl.registerFactory(
    () => TextToSignBloc(
      convertTextToSignUseCase: sl<ConvertTextToSignUseCase>(),
    ),
  );

  // ═════════════════════════════════════════════════════════════════
  // 7. Admin (✅ ترتيب صحيح)
  // ═════════════════════════════════════════════════════════════════

  // 7.1 Data Layer
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl<Dio>()),
  );
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl<AdminRemoteDataSource>()),
  );

  // 7.2 Use Cases (✅ قبل الـ Bloc)
  // ✅ GetWordsUseCase للـ Admin (مش Dictionary)
  sl.registerLazySingleton<GetWordsUseCaseAdmin>(
    () => GetWordsUseCaseAdmin(sl<AdminRepository>()),
    instanceName: 'adminGetWords',
  );
  sl.registerLazySingleton(() => AddWordUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(() => UpdateWordUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(() => DeleteWordUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(() => GetCategoriesUseCaseAdmin(sl<AdminRepository>()));
  sl.registerLazySingleton(() => AddCategoryUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(() => GetWordRequestsUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(() => AcceptRequestUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(() => RejectRequestUseCase(sl<AdminRepository>()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl<AdminRepository>()));

  // 7.3 Bloc (✅ بعد الـ Use Cases)
  sl.registerFactory<AdminBloc>(
    () => AdminBloc(
      getWords: sl<GetWordsUseCaseAdmin>(instanceName: 'adminGetWords'),
      addWord: sl<AddWordUseCase>(),
      updateWord: sl<UpdateWordUseCase>(),
      deleteWord: sl<DeleteWordUseCase>(),
      getCategories: sl<GetCategoriesUseCaseAdmin>(),
      addCategory: sl<AddCategoryUseCase>(),
      deleteCategory: sl<DeleteCategoryUseCase>(),
      getRequests: sl<GetWordRequestsUseCase>(),
      acceptRequest: sl<AcceptRequestUseCase>(),
      rejectRequest: sl<RejectRequestUseCase>(),
      getUsers: sl<GetUsersUseCase>(),
    ),
  );
}
