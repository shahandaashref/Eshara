import '../entities/user.dart';
import '../repositories/profile_repository.dart';

/// [UseCase] — GetUserUseCase
/// بتجيب بيانات المستخدم الحالي
class GetUserUseCase {
  final ProfileRepository repository;
  GetUserUseCase(this.repository);

  Future<User> call() => repository.getUser();
}

/// [UseCase] — UpdateUserUseCase
/// بتحدث بيانات المستخدم وترجع الـ User المحدث
class UpdateUserUseCase {
  final ProfileRepository repository;
  UpdateUserUseCase(this.repository);

  Future<User> call(User user) => repository.updateUser(user);
}

/// [UseCase] — LogoutUseCase
/// بتعمل تسجيل خروج وتمسح بيانات الـ session
class LogoutUseCase {
  final ProfileRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call() => repository.logout();
}

/// [UseCase] — ToggleNotificationsUseCase
/// بتحدث حالة الإشعارات للمستخدم
class ToggleNotificationsUseCase {
  final ProfileRepository repository;
  ToggleNotificationsUseCase(this.repository);

  Future<void> call(bool enabled) => repository.toggleNotifications(enabled);
}
