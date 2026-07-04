import 'package:eshara/features/Profile/Data/datasources/profile_remote_datasource.dart';
import 'package:eshara/features/Profile/Domain/entities/profile_entity.dart';
import 'package:eshara/features/Profile/Domain/repositories/profile_repository.dart';


class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});
  @override
  Future<ProfileEntity> getProfile() async => remoteDataSource.getProfile();

  @override
  Future<void> logout() => remoteDataSource.logout();

  @override
  Future<void> updateProfile(ProfileEntity profile) =>
      remoteDataSource.updateProfile(profile);
}
