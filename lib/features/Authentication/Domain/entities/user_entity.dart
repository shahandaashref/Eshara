import 'package:jwt_decoder/jwt_decoder.dart';

class UserEntity {
  final String? id;
  final String email;
  final String? fullname;
  final String? token;
  final String role;

  UserEntity({
    this.id,
    required this.email,
    this.fullname,
    this.token,
    required this.role,
  });

  String get name =>
      (fullname?.trim().isNotEmpty ?? false) ? fullname!.trim() : email;

  factory UserEntity.fromToken(String token) {
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    
    // ✅ طباعة محتويات الـ Token للتأكد
    print('🔍 Decoded Token: $decodedToken');
    
    // ✅ استخراج الـ role من الـ Token بشكل صحيح
    String role = 'User'; // القيمة الافتراضية
    
    // قائمة بكل الـ keys المحتملة للـ role
    final possibleRoleKeys = [
      'http://schemas.microsoft.com/ws/2008/06/identity/claims/role',
      'role',
      'Role',
      'roles',
      'user_role',
      'userRole',
      'user_type',
      'userType',
    ];
    
    for (final key in possibleRoleKeys) {
      if (decodedToken.containsKey(key)) {
        final value = decodedToken[key];
        if (value is String && value.isNotEmpty) {
          role = value;
          break;
        } else if (value is List && value.isNotEmpty) {
          role = value.first.toString();
          break;
        }
      }
    }
    
    print('🎭 Extracted Role from token: "$role"');
    
    // استخراج الـ email
    final email = decodedToken['email'] ?? 
                  decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress'] ??
                  decodedToken['Email'] ??
                  '';
    
    // استخراج الـ name
    final name = decodedToken['name'] ?? 
                 decodedToken['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name'] ??
                 decodedToken['unique_name'] ??
                 decodedToken['fullname'] ??
                 '';
    
    return UserEntity(
      email: email,
      fullname: name,
      role: role,
      token: token,
    );
  }
  
  // ✅ دالة مساعدة لتحويل UserEntity إلى Map (للتخزين)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullname': fullname,
      'role': role,
      'token': token,
    };
  }
}