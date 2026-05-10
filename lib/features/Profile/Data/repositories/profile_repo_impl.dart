import 'package:eshara/features/Profile/Domin/entities/user.dart';
import 'package:eshara/features/Profile/Domin/repositories/profile_repository.dart';

import '../datasources/profile_remote_datasource.dart';
import '../models/user_model.dart';

/// [Repository Implementation] — ProfileRepositoryImpl
/// الوسيط بين الـ domain layer والـ data sources
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> getUser() async {
    return await remoteDataSource.getUser();
  }

  @override
  Future<User> updateUser(User user) async {
    // بنحول الـ User entity لـ UserModel قبل ما نبعته للـ datasource
    final model = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      avatarUrl: user.avatarUrl,
      notificationsEnabled: user.notificationsEnabled,
    );
    return await remoteDataSource.updateUser(model);
  }

  @override
  Future<void> logout() => remoteDataSource.logout();

  @override
  Future<void> toggleNotifications(bool enabled) =>
      remoteDataSource.toggleNotifications(enabled);
}
