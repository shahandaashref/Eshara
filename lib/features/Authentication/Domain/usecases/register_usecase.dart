import '../repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository repository;
  RegisterUseCase(this.repository);

  Future<void> call(String name, String email, String password) {
    // منطق العمل (Business Logic) ممكن يكون هنا، مثلاً:
    // التحقق من قوة كلمة المرور، أو التأكد من تنسيق الإيميل
    // لكن حالياً، سنمررها مباشرة إلى الـ Repository
    return repository.register(name, email, password);
  }
}
