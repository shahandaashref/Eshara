import '../entities/user.dart';

/// [Repository Contract] — ProfileRepository
/// بيحدد العمليات المتاحة على بيانات المستخدم.
abstract interface class ProfileRepository {
  /// بيجيب بيانات المستخدم الحالي
  Future<User> getUser();

  /// بيحدث بيانات المستخدم ويرجع الـ User المحدث
  Future<User> updateUser(User user);

  /// بيعمل تسجيل خروج
  Future<void> logout();

  /// بيحدث حالة الإشعارات (on/off)
  Future<void> toggleNotifications(bool enabled);
}
