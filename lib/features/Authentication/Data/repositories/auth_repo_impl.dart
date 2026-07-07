import 'dart:convert';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login(String email, String password) async {
    final response = await remoteDataSource.login(email, password);

    String role = response.role?.trim() ?? 'User';

    try {
      final parts = response.token.split('.');
      if (parts.length == 3) {
        final payload = json.decode(
          utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
        );

        if (payload is Map<String, dynamic>) {
          if (role == 'User') {
            final payloadRole = payload['role'];
            if (payloadRole is String && payloadRole.trim().isNotEmpty) {
              role = payloadRole.trim();
            }
          }

          if (role == 'User' && payload['roles'] != null) {
            final roles = payload['roles'];
            if (roles is String) {
              role = roles.trim();
            } else if (roles is List) {
              final adminRole = roles
                  .cast<dynamic>()
                  .map((e) => e?.toString().trim())
                  .firstWhere(
                    (e) => e != null && e.isNotEmpty,
                    orElse: () => null,
                  );
              if (adminRole != null) {
                role = adminRole;
              }
            }
          }
        }
      }
    } catch (_) {
      // تجاهل الأخطاء في فك التوكن، سنستخدم الدور الموجود في الاستجابة إذا وجد
    }

    return UserEntity(email: email, token: response.token, role: role);
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
