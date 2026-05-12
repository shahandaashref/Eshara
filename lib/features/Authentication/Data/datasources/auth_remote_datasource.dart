import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

abstract class AuthRemoteDataSource {
  Future<void> register(String name, String email, String password);
  Future<String> login(String email, String password);
  Future<void> verifyOtp(String email, String code);
  Future<void> resendOtp(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  // الرابط الأساسي للسيرفر
  final String baseUrl = 'https://eshara.runasp.net';

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<void> register(String name, String email, String password) async {
    try {
      // ملاحظة: تأكد من مسار الـ Endpoint في الـ Swagger
      final url = Uri.parse('$baseUrl/api/Auth/register');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name':
              name, // تأكد إن الاسم ده هو نفس المتوقع في الـ API (ممكن يكون userName)
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('فشل إنشاء الحساب: ${response.body}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء التسجيل: $e');
    }
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/Auth/login');

      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['token'] ?? ''; // افترضنا إن الـ API بيرجع الـ Token
      } else {
        throw Exception('البريد الإلكتروني أو كلمة المرور غير صحيحة');
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
        throw Exception('فشل التحقق من الكود: ${response.body}');
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
        throw Exception('فشل إعادة إرسال الكود: ${response.body}');
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء إعادة الإرسال: $e');
    }
  }
}
