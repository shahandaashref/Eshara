import '../../Domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../Domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    // 1. استدعاء الـ API اللي هيرجع التوكن (String)
    final token = await remoteDataSource.login(email, password);

    // 2. تحويل التوكن ده لـ UserEntity
    // (ملاحظة: تأكد من تمرير الحقول الصحيحة اللي موجودة جوه كلاس UserEntity عندك)
    return UserEntity(email: email, token: token,);
  }

  @override
  Future<void> register(String name, String email, String password) async {
    return await remoteDataSource.register(name, email, password);
  }

  // وتكملي باقي الدوال (verifyOtp, resetPassword) بنفس الطريقة
  @override
  Future<void> verifyOtp(String email, String code) async {
    return await remoteDataSource.verifyOtp(email, code);
  }

  @override
  Future<void> resetPassword(String email, String newPassword) async =>
      throw UnimplementedError();

  @override
  Future<void> resendOtp(String email) async {
    return await remoteDataSource.resendOtp(email);
  }
}
