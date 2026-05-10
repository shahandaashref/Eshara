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
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void initDependencies() {
  // ── Sign To Text ───────────────────────────────────────────────────────────
  // ── Data Sources ───────────────────────────────────────────────────────────
  sl.registerLazySingleton<SignRemoteDataSource>(
    () => SignRemoteDataSourceImpl(),
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
      () => ProfileRemoteDataSourceImpl());
  sl.registerLazySingleton<ProfileRepository>(_createProfileRepo);
  sl.registerLazySingleton(() => GetUserUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => UpdateUserUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<ProfileRepository>()));
  sl.registerLazySingleton(
      () => ToggleNotificationsUseCase(sl<ProfileRepository>()));
  sl.registerFactory<ProfileBloc>(() => ProfileBloc(
        getUserUseCase: sl(),
        updateUserUseCase: sl(),
        logoutUseCase: sl(),
        toggleNotificationsUseCase: sl(),
      ));

}

/// top-level function بـ return type صريح
/// Dart بيشوف الـ return type هنا ويعرف إن SignRepositoryImpl هو SignRepository
// SignRepository _createRepo() =>
//     SignRepositoryImpl(remoteDataSource: sl<SignRemoteDataSource>());

ProfileRepository _createProfileRepo() =>
    ProfileRepositoryImpl(remoteDataSource: sl<ProfileRemoteDataSource>());