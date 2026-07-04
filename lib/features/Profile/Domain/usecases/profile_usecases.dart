import 'package:eshara/features/Profile/Domain/entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

/// [UseCase] — GetProfileUseCase
/// بتجيب بيانات المستخدم الحالي
class GetProfileUseCase {
  final ProfileRepository repository;
  GetProfileUseCase(this.repository);

  Future<ProfileEntity> call() => repository.getProfile();
}

/// [UseCase] — UpdateProfileUseCase
/// بتحدث بيانات المستخدم وترجع الـ User المحدث
class UpdateProfileUseCase {
  final ProfileRepository repository;
  UpdateProfileUseCase(this.repository);

  Future<void> call(ProfileEntity profile) => repository.updateProfile(profile);
}

/// [UseCase] — LogoutUseCase
/// بتعمل تسجيل خروج وتمسح بيانات الـ session
class LogoutUseCase {
  final ProfileRepository repository;
  LogoutUseCase(this.repository);

  Future<void> call() => repository.logout();
}
