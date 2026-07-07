import 'package:dio/dio.dart';
import 'package:eshara/current_user_store.dart';
import 'package:flutter/material.dart';

/// [Interceptor] — بيفحص الـ 401 ويعمل logout تلقائي
class AuthInterceptor extends Interceptor {
  final Dio dio;
  final CurrentUserStore _userStore = CurrentUserStore.instance;

  AuthInterceptor({required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _userStore.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      print('🔑 Token attached to request: ${token.substring(0, 20)}...');
    } else {
      print('⚠️ No token available for request');
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      print('🔴 401 Unauthorized — Token expired or invalid!');

      // ✅ نعمل logout تلقائي
      await _userStore.clear();

      // ✅ نبعت event للـ UI عشان يودّي المستخدم لـ Login
      _userStore.onTokenExpired?.call();

      return handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى',
          type: DioExceptionType.badResponse,
        ),
      );
    }

    return handler.next(err);
  }
}