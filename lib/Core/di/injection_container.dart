import 'package:dio/dio.dart';
import 'package:eshara/features/Authentication/Domain/usecases/verify_otp_usecase.dart';
import 'package:eshara/features/admin/Data/datasources/admin_remote_datasource.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eshara/features/admin/Data/repositories/admin_repo_impl.dart';
import 'package:eshara/features/admin/Domain/repositorys/admin_repository.dart';
import 'package:eshara/features/admin/domain/usecases/admin_usecases.dart';
import 'package:eshara/features/addword/Data/datasources/add_word_remote_datasource.dart';
import 'package:eshara/features/addword/Data/repositories/add_word_repository_impl.dart';
import 'package:eshara/features/addword/Domain/repositories/add_word_repository.dart';
import 'package:eshara/features/addword/Domain/usecases/submit_word_request_usecase.dart';
import 'package:eshara/features/Dictionary/Data/datasources/dictionary_remote_datasource.dart';
import 'package:eshara/features/Dictionary/Data/repositories/dictionary_repo_impl.dart';
import 'package:eshara/features/Dictionary/Domin/repositories/dictionary_repository.dart';
import 'package:eshara/features/Dictionary/Domin/usecases/get_signs_usecase.dart';
import 'package:eshara/features/Dictionary/Domin/usecases/search_signs_usecase.dart';
import 'package:eshara/features/Dictionary/Ui/bloc/dictionary_bloc.dart';
import 'package:eshara/features/Profile/Data/datasources/profile_remote_datasource.dart';
import 'package:eshara/features/Profile/Data/repositories/profile_repo_impl.dart';
import 'package:eshara/features/Profile/Domin/repositories/profile_repository.dart';
import 'package:eshara/features/Profile/Domin/usecases/profile_usecases.dart';
import 'package:eshara/features/Profile/Ui/bloc/profile_bloc.dart';
import 'package:eshara/features/SignToText/Data/datasources/sign_remote_datasource.dart';
import 'package:eshara/features/SignToText/Data/repositories/sign_repo_impl.dart';
import 'package:eshara/features/SignToText/Domain/repositories/sign_repository.dart';

import 'package:eshara/features/SignToText/Domain/usecases/translate_sign.dart';
import 'package:eshara/features/SignToText/UI/bloc/sign_bloc.dart';
import 'package:eshara/features/Authentication/Data/datasources/auth_remote_datasource.dart';
import 'package:eshara/features/Authentication/Data/repositories/auth_repo_impl.dart';
import 'package:eshara/features/Authentication/Domain/repositories/auth_repository.dart';
import 'package:eshara/features/Authentication/Domain/usecases/login_usecase.dart';
import 'package:eshara/features/Authentication/Domain/usecases/register_usecase.dart';
import 'package:eshara/features/Authentication/Domain/usecases/resend_otp_usecase.dart';

import 'package:eshara/features/admin/UI/bloc/admin_bloc.dart';
import 'package:eshara/features/addword/UI/bloc/add_word_bloc.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:eshara/features/Text_to_sign/domain/usecases/convert_text_to_sign.dart';
import 'package:eshara/features/Text_to_sign/Ui/bloc/text_to_sign_bloc.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;
bool _dependenciesInitialized = false;

Future<void> initDependencies() async {
  if (_dependenciesInitialized) return;
  _dependenciesInitialized = true;

  // 0. Shared Preferences
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
  await sl.isReady<SharedPreferences>();

  // ── Authentication ────────────────────────────────────────────────────────

  // 1. Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl(), sharedPreferences: sl()),
  );

  // 2. Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // 3. Use Cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResendOtpUseCase(sl()));

  // 4. BLoC
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      verifyOtpUseCase: sl(),
      resendOtpUseCase: sl(), // تم إصلاح الاعتمادية الناقصة
    ),
  );

  // ── Sign To Text ───────────────────────────────────────────────────────────
  // ── Data Sources ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<SignRemoteDataSource>(
    () => SignRemoteDataSourceImpl(client: sl()),
  );

  // ── Repositories ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<SignRepository>(
    () => SignRepositoryImpl(remoteDataSource: sl<SignRemoteDataSource>()),
  );

  // ── Use Cases ──────────────────────────────────────────────────────────────
  sl.registerLazySingleton<TranslateSignUseCase>(
    () => TranslateSignUseCase(sl<SignRepository>()),
  );

  // ── BLoC ───────────────────────────────────────────────────────────────────
  sl.registerFactory<SignBloc>(
    () => SignBloc(translateSignUseCase: sl<TranslateSignUseCase>()),
  );

  // ── Profile ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ProfileRepository>(_createProfileRepo);
  sl.registerLazySingleton(() => GetUserUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(
    () => ToggleNotificationsUseCase(sl<ProfileRepository>()),
  );
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getUserUseCase: sl(),
      updateUserUseCase: sl(),
      logoutUseCase: sl(),
      toggleNotificationsUseCase: sl(),
    ),
  );

  // Dictionary Feature
  // ── Dictionary ───────────────────────────────────────────────────────────
  // ── External ──
  // لازم نسجل Dio كـ Singleton عشان الـ Data Source يشوفه
  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: 'https://eshara.runasp.net'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sl<SharedPreferences>().getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
    return dio;
  });
  sl.registerLazySingleton(() => http.Client());

  // ── Dictionary Feature ──

  // 1. Data Sources
  sl.registerLazySingleton<DictionaryRemoteDataSource>(
    () => DictionaryRemoteDataSourceImpl(
      dio: sl(),
    ), // بنبعت الـ Dio اللي سجلناه فوق
  );

  // 2. Repositories
  sl.registerLazySingleton<DictionaryRepository>(
    () => DictionaryRepositoryImpl(remoteDataSource: sl()),
  );

  // 3. Use Cases
  sl.registerLazySingleton(() => GetSignsUseCase(sl()));
  sl.registerLazySingleton(() => SearchSignsUseCase(sl()));

  // 4. Bloc
  sl.registerFactory(
    () => DictionaryBloc(getSignsUseCase: sl(), searchSignsUseCase: sl()),
  );

  // ── Add Word Feature ─────────────────────────────────────────────────────
  sl.registerLazySingleton<AddWordRemoteDataSource>(
    () => AddWordRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<AddWordRepository>(
    () => AddWordRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<SubmitWordRequestUseCase>(
    () => SubmitWordRequestUseCase(sl<AddWordRepository>()),
  );
  sl.registerFactory<AddWordBloc>(
    () => AddWordBloc(submitWordRequestUseCase: sl<SubmitWordRequestUseCase>()),
  );

  // ── Text To Sign ───────────────────────────────────────────────────────────

  // 1. تسجيل الـ UseCase الخاص بـ Text To Sign
  // (استخدمنا النسخة المؤقتة بدون Repository لتشغيل التطبيق وتخطي الخطأ)
  sl.registerLazySingleton(() => ConvertTextToSignUseCase());

  // 2. استخدام sl() بدلاً من null حتى يقوم GetIt بالبحث عن الـ UseCase وحقنه بنجاح
  sl.registerFactory(() => TextToSignBloc(convertTextToSignUseCase: sl()));

  // ── Admin ──────────────────────────────────────────────────────────────

  // 1. Data Sources
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(dio: sl()),
  );

  // 2. Repositories
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );

  // 3. Use Cases
  sl.registerLazySingleton(() => GetStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetWordsUseCase(sl()));
  sl.registerLazySingleton(() => AddWordUseCase(sl()));
  sl.registerLazySingleton(() => UpdateWordUseCase(sl()));
  sl.registerLazySingleton(() => DeleteWordUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => AddCategoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));
  sl.registerLazySingleton(() => GetWordRequestsUseCase(sl()));
  sl.registerLazySingleton(() => AcceptRequestUseCase(sl()));
  sl.registerLazySingleton(() => RejectRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));

  // 4. BLoC
  sl.registerFactory<AdminBloc>(
    () => AdminBloc(
      getStats: sl(),
      getWords: sl(),
      addWord: sl(),
      updateWord: sl(),
      deleteWord: sl(),
      getCategories: sl(),
      addCategory: sl(),
      deleteCategory: sl(),
      getRequests: sl(),
      acceptRequest: sl(),
      rejectRequest: sl(),
      getUsers: sl(),
    ),
  );
}

/// top-level function بـ return type صريح
/// Dart بيشوف الـ return type هنا ويعرف إن SignRepositoryImpl هو SignRepository
// SignRepository _createRepo() =>
//     SignRepositoryImpl(remoteDataSource: sl<SignRemoteDataSource>());

ProfileRepository _createProfileRepo() =>
    ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>());
