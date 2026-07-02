import 'package:eshara/Core/Helper/current_user_store.dart';

import '../models/user_model.dart';

/// [DataSource Contract] — ProfileRemoteDataSource
abstract class ProfileRemoteDataSource {
  Future<UserModel> getUser();
  Future<UserModel> updateUser(UserModel user);
  Future<void> logout();
  Future<void> toggleNotifications(bool enabled);
}

/// [DataSource Implementation] — ProfileRemoteDataSourceImpl
/// دلوقتي بترجع mock data — استبدلها بـ HTTP calls حقيقية
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  /// [getUser] — بيجيب بيانات المستخدم من الـ API
  /// TODO: استبدل بـ GET /api/user
  @override
  Future<UserModel> getUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final store = CurrentUserStore.instance;
    final name = store.name.isNotEmpty ? store.name : '';
    final email = store.email.isNotEmpty ? store.email : '';

    return UserModel(
      id: '1',
      name: name,
      email: email,
      notificationsEnabled: true,
    );
  }

  /// [updateUser] — بيبعت التعديلات الجديدة للـ API
  /// TODO: استبدل بـ PUT /api/user
  @override
  Future<UserModel> updateUser(UserModel user) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return user;
  }

  /// [logout] — بيمسح الـ session ويعمل تسجيل خروج
  /// TODO: استبدل بـ POST /api/logout
  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  /// [toggleNotifications] — بيحدث حالة الإشعارات في الـ API
  /// TODO: استبدل بـ PATCH /api/user/notifications
  @override
  Future<void> toggleNotifications(bool enabled) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
