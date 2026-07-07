import 'package:eshara/features/Authentication/domain/repositories/auth_repository.dart';



class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<void> call(String email, String code) async {
    return await repository.verifyOtp(email, code);
  }
}
