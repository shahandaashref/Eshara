import 'dart:convert';
import 'package:eshara/current_user_store.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class AuthLoginResponse {
  final String token;
  final String? role;

  AuthLoginResponse({required this.token, this.role});
}

abstract class AuthRemoteDataSource {
  Future<void> register(String name, String email, String password);
  Future<AuthLoginResponse> login(String email, String password);
  Future<void> verifyOtp(String email, String code);
  Future<void> resendOtp(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final SharedPreferences sharedPreferences;
  // الرابط الأساسي للسيرفر
  static const String baseUrl = 'https://eshara.runasp.net';

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.sharedPreferences,
  });

  Map<String, dynamic> _decodeJsonBody(String responseBody) {
    final decoded = json.decode(responseBody);
    if (decoded is Map<String, dynamic>) return decoded;
    if (decoded is Map) return Map<String, dynamic>.from(decoded);
    throw Exception('تنسيق استجابة غير صالح من الخادم');
  }

  /// دالة مساعدة لاستخراج رسالة الخطأ من السيرفر بذكاء
  String _getErrorMessage(String responseBody) {
    try {
      final data = json.decode(responseBody);
      if (data is Map<String, dynamic>) {
        // البحث في المفاتيح الشائعة التي ترسلها الخوادم (خاصة .NET APIs)
        if (data.containsKey('message')) {
          return data['message'].toString();
        }
        if (data.containsKey('description')) {
          return data['description'].toString();
        }
        if (data.containsKey('title') && !data.containsKey('errors')) {
          return data['title'].toString();
        }

        // إذا كان هناك قائمة أخطاء تفصيلية (Validation Errors)
        if (data.containsKey('errors')) {
          final errors = data['errors'];
          if (errors is Map && errors.isNotEmpty) {
            final firstError = errors.values.first;
            if (firstError is List && firstError.isNotEmpty) {
              return firstError.first
                  .toString(); // يرجع أول خطأ موجود (مثلاً: البريد مستخدم مسبقاً)
            }
          }
        }
      }
      return responseBody.length < 100 ? responseBody : 'حدث خطأ في الخادم';
    } catch (_) {
      return 'حدث خطأ غير متوقع أو أن السيرفر لا يستجيب'; // في حال لم يكن الرد من نوع JSON
    }
  }

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      // ملاحظة: تأكد من مسار الـ Endpoint في الـ Swagger
      final url = Uri.parse('$baseUrl/api/Auth/register');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fullName': name,
          'email': email,
          'password': password,
        }),
      );

      debugPrint('Register Response Status: ${response.statusCode}');
      debugPrint('Register Response Body: ${response.body}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception(_getErrorMessage(response.body));
      }

      CurrentUserStore().setUser(name: name, email: email);
    } catch (e) {
      throw Exception('حدث خطأ أثناء التسجيل: $e');
    }
  }

  @override
  Future<AuthLoginResponse> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/Auth/login');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      debugPrint('Login Response Status: ${response.statusCode}');
      debugPrint('Login Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = _decodeJsonBody(response.body);
        final token =
            data['token'] ??
            data['accessToken'] ??
            (data['data'] is Map ? (data['data'] as Map)['token'] : null);

        if (token is String && token.isNotEmpty) {
          String? role;

          String? getString(dynamic value) {
            if (value is String && value.trim().isNotEmpty) return value.trim();
            return null;
          }

          if (data.containsKey('role')) {
            role = getString(data['role']);
          }

          if (role == null && data.containsKey('roles')) {
            final roles = data['roles'];
            if (roles is String) {
              role = getString(roles);
            } else if (roles is List && roles.isNotEmpty) {
              role = getString(roles.first);
            }
          }

          if (role == null && data.containsKey('data') && data['data'] is Map) {
            final nested = Map<String, dynamic>.from(data['data'] as Map);
            role = getString(nested['role']);
            if (role == null && nested.containsKey('roles')) {
              final nestedRoles = nested['roles'];
              if (nestedRoles is String) {
                role = getString(nestedRoles);
              } else if (nestedRoles is List && nestedRoles.isNotEmpty) {
                role = getString(nestedRoles.first);
              }
            }
          }

          // الخطوة الأهم: حفظ التوكن في الذاكرة الدائمة
          await sharedPreferences.setString('auth_token', token);

          // نقوم الآن بتمرير الدور الذي حصلنا عليه من الخادم
          CurrentUserStore().setUser(name: '', email: email, role: role);
          return AuthLoginResponse(token: token, role: role);
        }

        throw Exception('لم يتم استلام رمز الدخول من الخادم');
      } else {
        final errorMessage = _getErrorMessage(response.body);
        // إذا كانت الرسالة العامة (حدث خطأ في الخادم) نضع رسالة مخصصة لتسجيل الدخول
        throw Exception(
          errorMessage.contains('حدث خطأ')
              ? 'البريد الإلكتروني أو كلمة المرور غير صحيحة'
              : errorMessage,
        );
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء تسجيل الدخول: $e');
    }
  }

  @override
  Future<void> verifyOtp(String email, String code) async {
    try {
      final url = Uri.parse('$baseUrl/api/Auth/verify-email');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'code': code, // تأكد من اسم المتغير في Swagger (قد يكون otp أو token)
        }),
      );

      if (response.statusCode != 200) {
        throw Exception(_getErrorMessage(response.body));
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء التحقق: $e');
    }
  }

  @override
  Future<void> resendOtp(String email) async {
    try {
      final url = Uri.parse('$baseUrl/api/Auth/resend-email');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode != 200) {
        throw Exception(_getErrorMessage(response.body));
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء إعادة الإرسال: $e');
    }
  }
}
