import 'package:dio/dio.dart';
import 'package:eshara/features/Authentication/UI/Screens/verify_otp_usecase.dart';
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
import 'package:eshara/features/Authentication/UI/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

final sl = GetIt.instance;

void initDependencies() {
  // ── Authentication ────────────────────────────────────────────────────────

  // 1. Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
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
      resendOtpUseCase: sl(),
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
  sl.registerLazySingleton(() => Dio());
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
}

/// top-level function بـ return type صريح
/// Dart بيشوف الـ return type هنا ويعرف إن SignRepositoryImpl هو SignRepository
// SignRepository _createRepo() =>
//     SignRepositoryImpl(remoteDataSource: sl<SignRemoteDataSource>());

ProfileRepository _createProfileRepo() =>
    ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>());
