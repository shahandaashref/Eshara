// import 'package:dio/dio.dart';
// import 'package:eshara/Core/constants/api_constants.dart';
// import 'package:eshara/features/Authentication/Data/datasources/auth_remote_datasource.dart';
// import 'package:eshara/features/Authentication/Data/repositories/auth_repo_impl.dart';
// import 'package:eshara/features/Authentication/Domain/repositories/auth_repository.dart';
// import 'package:eshara/features/Authentication/Domain/usecases/login_usecase.dart';
// import 'package:eshara/features/Authentication/Domain/usecases/register_usecase.dart';
// import 'package:eshara/features/Authentication/Domain/usecases/resend_otp_usecase.dart';
// import 'package:eshara/features/Authentication/Domain/usecases/verify_otp_usecase.dart';
// import 'package:eshara/features/Authentication/UI/bloc/auth_bloc.dart';
// import 'package:eshara/features/Dictionary/Domain/repositories/dictionary_repository.dart';
// import 'package:eshara/features/Dictionary/Domain/usecases/get_signs_usecase.dart';
// import 'package:eshara/features/Dictionary/Domain/usecases/search_signs_usecase.dart';
// import 'package:eshara/features/SignToText/Data/datasources/sign_remote_datasource.dart';
// import 'package:eshara/features/SignToText/Data/repositories/sign_repo_impl.dart';
// import 'package:eshara/features/SignToText/Domain/repositories/sign_repository.dart';
// import 'package:eshara/features/SignToText/Domain/usecases/translate_sign.dart';
// import 'package:eshara/features/SignToText/UI/bloc/sign_bloc.dart';
// import 'package:eshara/features/Profile/Data/datasources/profile_remote_datasource.dart';
// import 'package:eshara/features/Profile/Data/repositories/profile_repo_impl.dart';
// import 'package:eshara/features/Profile/Domain/repositories/profile_repository.dart';
// import 'package:eshara/features/Profile/Domain/usecases/profile_usecases.dart';
// import 'package:eshara/features/Profile/UI/bloc/profile_bloc.dart';
// import 'package:eshara/features/Dictionary/Data/datasources/dictionary_remote_datasource.dart';
// import 'package:eshara/features/Dictionary/Data/repositories/dictionary_repo_impl.dart';
// import 'package:eshara/features/Dictionary/UI/bloc/dictionary_bloc.dart';
// import 'package:eshara/features/Text_to_sign/domain/usecases/convert_text_to_sign.dart';
// import 'package:eshara/features/addword/Data/datasources/add_word_remote_datasource.dart';
// import 'package:eshara/features/addword/Data/repositories/add_word_repository_impl.dart';
// import 'package:eshara/features/addword/Domain/repositories/add_word_repository.dart';
// import 'package:eshara/features/addword/Domain/usecases/submit_word_request_usecase.dart';
// import 'package:eshara/features/addword/UI/bloc/add_word_bloc.dart';
// import 'package:eshara/features/Text_to_sign/Data/datasources/text_to_sign_datasource.dart';
// import 'package:eshara/features/Text_to_sign/Data/repositories/text_to_sign_repo_impl.dart';
// import 'package:eshara/features/Text_to_sign/domain/repositories/text_to_sign_repository.dart';
// import 'package:eshara/features/Text_to_sign/UI/bloc/text_to_sign_bloc.dart';
// import 'package:eshara/features/admin/Data/datasources/admin_remote_datasource.dart';
// import 'package:eshara/features/admin/Data/repositories/admin_repo_impl.dart';
// import 'package:eshara/features/admin/Domain/repositories/admin_repository.dart';
// import 'package:eshara/features/admin/Domain/usecases/admin_usecases.dart';
// import 'package:eshara/features/admin/UI/bloc/admin_bloc.dart';
// import 'package:get_it/get_it.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final sl = GetIt.instance;

// Future<void> initDependencies() async {
//   // ============================================================
//   // 1. External Dependencies
//   // ============================================================

//   // Shared Preferences (Async)
//   final sharedPreferences = await SharedPreferences.getInstance();
//   sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

//   // ✅ Dio Client (من غير Interceptors دلوقتي عشان نبعد عن الأخطاء)
//   sl.registerLazySingleton<Dio>(() {
//     return Dio(
//       BaseOptions(
//         baseUrl: ApiConstants.baseUrl,
//         connectTimeout: const Duration(
//           milliseconds: ApiConstants.connectTimeout,
//         ),
//         receiveTimeout: const Duration(
//           milliseconds: ApiConstants.receiveTimeout,
//         ),
//         sendTimeout: const Duration(milliseconds: ApiConstants.sendTimeout),
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': 'application/json',
//         },
//       ),
//     );
//   });

//   // ============================================================
//   // 2. Initialize All Features
//   // ============================================================
//   _initAuth();
//   _initSignToText();
//   _initProfile();
//   _initDictionary();
//   _initAddWord();
//   _initTextToSign();
//   _initAdmin();
// }

// // ============================================================
// // AUTH Feature
// // ============================================================
// void _initAuth() {
//   // Data Sources
//   sl.registerLazySingleton<AuthRemoteDataSource>(
//     () => AuthRemoteDataSourceImpl(
//       client: sl(),
//       sharedPreferences: sl<SharedPreferences>(),
//     ),
//   );

//   // Repositories
//   sl.registerLazySingleton<AuthRepository>(
//     () => AuthRepositoryImpl(remoteDataSource: sl<AuthRemoteDataSource>()),
//   );

//   // Use Cases
//   sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
//   sl.registerLazySingleton(() => RegisterUseCase(sl<AuthRepository>()));
//   sl.registerLazySingleton(() => VerifyOtpUseCase(sl<AuthRepository>()));
//   sl.registerLazySingleton(() => ResendOtpUseCase(sl<AuthRepository>()));

//   // BLoC
//   sl.registerFactory(
//     () => AuthBloc(
//       loginUseCase: sl<LoginUseCase>(),
//       registerUseCase: sl<RegisterUseCase>(),
//       verifyOtpUseCase: sl<VerifyOtpUseCase>(),
//       resendOtpUseCase: sl<ResendOtpUseCase>(),
//     ),
//   );
// }

// // ============================================================
// // SIGN TO TEXT Feature
// // ============================================================
// void _initSignToText() {
//   // Data Sources
//   sl.registerLazySingleton<SignRemoteDataSource>(
//     () => SignRemoteDataSourceImpl(dio: sl<Dio>(), client: sl()),
//   );

//   // Repositories
//   sl.registerLazySingleton<SignRepository>(
//     () => SignRepositoryImpl(remoteDataSource: sl<SignRemoteDataSource>()),
//   );

//   // Use Cases
//   sl.registerLazySingleton(() => TranslateSignUseCase(sl<SignRepository>()));

//   // BLoC
//   sl.registerFactory(
//     () => SignBloc(translateSignUseCase: sl<TranslateSignUseCase>()),
//   );
// }

// // ============================================================
// // PROFILE Feature
// // ============================================================
// void _initProfile() {
//   // Data Sources
//   sl.registerLazySingleton<ProfileRemoteDataSource>(
//     () => ProfileRemoteDataSourceImpl(dio: sl<Dio>()),
//   );

//   // Repositories
//   sl.registerLazySingleton<ProfileRepository>(
//     () =>
//         ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>()),
//   );

//   // Use Cases
//   sl.registerLazySingleton(() => GetProfileUseCase(sl<ProfileRepository>()));
//   sl.registerLazySingleton(() => UpdateProfileUseCase(sl<ProfileRepository>()));
//   sl.registerLazySingleton(() => LogoutUseCase(sl<ProfileRepository>()));

//   // BLoC
//   sl.registerFactory(
//     () => ProfileBloc(
//       getProfileUseCase: sl<GetProfileUseCase>(),
//       updateProfileUseCase: sl<UpdateProfileUseCase>(),
//       logoutUseCase: sl<LogoutUseCase>(),
//     ),
//   );
// }

// // ============================================================
// // DICTIONARY Feature
// // ============================================================
// void _initDictionary() {
//   // Data Sources
//   sl.registerLazySingleton<DictionaryRemoteDataSource>(
//     () => DictionaryRemoteDataSourceImpl(dio: sl<Dio>()),
//   );

//   // Repositories
//   sl.registerLazySingleton<DictionaryRepository>(
//     () => DictionaryRepositoryImpl(
//       remoteDataSource: sl<DictionaryRemoteDataSource>(),
//     ),
//   );

//   // Use Cases
//   sl.registerLazySingleton(() => GetSignsUseCase(sl<DictionaryRepository>()));
//   sl.registerLazySingleton(
//     () => SearchSignsUseCase(sl<DictionaryRepository>()),
//   );

//   // BLoC
//   sl.registerFactory(
//     () => DictionaryBloc(
//       getSignsUseCase: sl<GetSignsUseCase>(),
//       searchSignsUseCase: sl<SearchSignsUseCase>(),
//     ),
//   );
// }

// // ============================================================
// // ADD WORD Feature
// // ============================================================
// void _initAddWord() {
//   // Data Sources
//   sl.registerLazySingleton<AddWordRemoteDataSource>(
//     () => AddWordRemoteDataSourceImpl(dio: sl<Dio>()),
//   );

//   // Repositories
//   sl.registerLazySingleton<AddWordRepository>(
//     () =>
//         AddWordRepositoryImpl(remoteDataSource: sl<AddWordRemoteDataSource>()),
//   );

//   // Use Cases
//   sl.registerLazySingleton(
//     () => SubmitWordRequestUseCase(sl<AddWordRepository>()),
//   );

//   // BLoC
//   sl.registerFactory(
//     () => AddWordBloc(submitWordRequestUseCase: sl<SubmitWordRequestUseCase>()),
//   );
// }

// // ============================================================
// // ✅ TEXT TO SIGN Feature (المعدل)
// // ============================================================
// void _initTextToSign() {
//   // Data Sources
//   sl.registerLazySingleton<TextToSignRemoteDataSource>(
//     () => TextToSignRemoteDataSourceImpl(dio: sl<Dio>()),
//   );

//   // Repositories
//   sl.registerLazySingleton<TextToSignRepository>(
//     () => TextToSignRepositoryImpl(
//       remoteDataSource: sl<TextToSignRemoteDataSource>(),
//     ),
//   );

//   // ✅ Use Case - من غير <ConvertTextToSignUseCase> عشان نقلل الأخطاء
//   sl.registerLazySingleton(
//     () => ConvertTextToSignUseCase(sl<TextToSignRepository>()),
//   );

//   // ✅ BLoC
//   sl.registerFactory(
//     () => TextToSignBloc(convertTextToSignUseCase: sl<ConvertTextToSignUseCase>())
//       //convertTextToSignUseCase: sl<ConvertTextToSignUseCase>(),
    
//   );
// }

// // ============================================================
// // ADMIN Feature
// // ============================================================
// void _initAdmin() {
//   // Data Sources
//   sl.registerLazySingleton<AdminRemoteDataSource>(
//     () => AdminRemoteDataSourceImpl(dio: sl<Dio>()),
//   );

//   // Repositories
//   sl.registerLazySingleton<AdminRepository>(
//     () => AdminRepositoryImpl(remoteDataSource: sl<AdminRemoteDataSource>()),
//   );

//   // Use Cases
//   sl.registerLazySingleton(() => GetWordsUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => AddWordUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => UpdateWordUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => DeleteWordUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => GetCategoriesUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => AddCategoryUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => DeleteCategoryUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => GetWordRequestsUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => AcceptRequestUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => RejectRequestUseCase(sl<AdminRepository>()));
//   sl.registerLazySingleton(() => GetUsersUseCase(sl<AdminRepository>()));

//   // BLoC
//   sl.registerFactory(
//     () => AdminBloc(
//       getWords: sl<GetWordsUseCase>(),
//       addWord: sl<AddWordUseCase>(),
//       updateWord: sl<UpdateWordUseCase>(),
//       deleteWord: sl<DeleteWordUseCase>(),
//       getCategories: sl<GetCategoriesUseCase>(),
//       addCategory: sl<AddCategoryUseCase>(),
//       deleteCategory: sl<DeleteCategoryUseCase>(),
//       getRequests: sl<GetWordRequestsUseCase>(),
//       acceptRequest: sl<AcceptRequestUseCase>(),
//       rejectRequest: sl<RejectRequestUseCase>(),
//       getUsers: sl<GetUsersUseCase>(),
//     ),
//   );
// }

// // ============================================================
// // Helper Functions
// // ============================================================

// /// إعادة تعيين جميع التبعيات (للاستخدام في الاختبارات أو تسجيل الخروج)
// void resetDependencies() {
//   sl.reset();
// }

// /// الحصول على التوكن المخزن
// String? getAuthToken() {
//   return sl<SharedPreferences>().getString('auth_token');
// }

// /// تخزين التوكن
// Future<void> setAuthToken(String token) async {
//   await sl<SharedPreferences>().setString('auth_token', token);
// }

// /// حذف التوكن (تسجيل الخروج)
// Future<void> clearAuthToken() async {
//   await sl<SharedPreferences>().remove('auth_token');
//   await sl<SharedPreferences>().remove('user_data');
// }