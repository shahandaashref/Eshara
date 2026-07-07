// lib/core/utils/jwt_helper.dart
import 'package:jwt_decoder/jwt_decoder.dart';

class JwtHelper {
  /// فك الـ Token واستخراج البيانات
  static Map<String, dynamic> decodeToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      print('✅ Token decoded successfully');
      return decodedToken;
    } catch (e) {
      print('❌ Error decoding token: $e');
      return {};
    }
  }

  /// استخراج الـ role من الـ Token
  static String? getRoleFromToken(String token) {
    try {
      final decoded = decodeToken(token);
      return decoded['role'] ?? 
             decoded['Role'] ?? 
             decoded['user_role'] ?? 
             decoded['userRole'] ?? 
             decoded['roles']?.first?.toString() ??
             null;
    } catch (e) {
      return null;
    }
  }

  /// استخراج الـ email من الـ Token
  static String? getEmailFromToken(String token) {
    try {
      final decoded = decodeToken(token);
      return decoded['email'] ?? 
             decoded['Email'] ?? 
             decoded['sub'] ?? 
             null;
    } catch (e) {
      return null;
    }
  }

  /// استخراج الـ name من الـ Token
  static String? getNameFromToken(String token) {
    try {
      final decoded = decodeToken(token);
      return decoded['name'] ?? 
             decoded['Name'] ?? 
             decoded['username'] ?? 
             decoded['user_name'] ??
             decoded['fullName'] ??
             decoded['displayName'] ??
             null;
    } catch (e) {
      return null;
    }
  }
}