import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<void> register(String name, String email, String password);
  Future<void> verifyOtp(String email, String code);
  Future<void> resetPassword(String email, String newPassword);
  Future<void> resendOtp(String email);
}
