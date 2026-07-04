import 'package:jwt_decoder/jwt_decoder.dart';

class UserEntity {
  final String email;
  final String? fullname;
  final String? token;
  final String role;

  UserEntity({
    required this.email,
    this.fullname,
    this.token,
    required this.role,
  });

  String get name =>
      (fullname?.trim().isNotEmpty ?? false) ? fullname!.trim() : email;

  factory UserEntity.fromToken(String token) {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return UserEntity(
      email: decodedToken['email'] ?? '',
      fullname: decodedToken['name'] ?? '',
      // تحديث مفتاح الدور ليطابق ما يرسله الخادم
      role:
          decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
          'User',
      token: token,
    );
  }
}
