import '../repositories/auth_repository.dart';

class ResendOtpUseCase {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  Future<void> call(String email) async {
    return await repository.resendOtp(email);
  }
}
