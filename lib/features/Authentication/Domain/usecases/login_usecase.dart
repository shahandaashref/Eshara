import '../repositories/auth_repository.dart';
import '../entities/user_entity.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password) async {
    // الـ UseCase يجب أن يكون بسيطاً.
    // مهمة تحليل استجابة الـ API وتحويلها إلى UserEntity هي مسؤولية الـ Repository في طبقة الـ Data.
    // الـ UseCase يستدعي الـ Repository ويتوقع منه الحصول على UserEntity مباشرة.
    return repository.login(email, password);
  }
}
