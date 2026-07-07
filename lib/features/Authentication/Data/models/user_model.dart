import 'package:jwt_decoder/jwt_decoder.dart';

import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    super.fullname,
    super.token,
    required super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'] as String?;
    final decodedToken = token != null
        ? JwtDecoder.decode(token)
        : <String, dynamic>{};
    return UserModel(
      email: decodedToken['email'] ?? '',
      fullname: decodedToken['name'] ?? '',
      token: token,
      role:
          decodedToken['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'] ??
          'User',
    );
  }
}
