import 'package:dio/dio.dart';
import 'package:eshara/Core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;

  AuthInterceptor(this.sharedPreferences);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // التحقق من أن المسار ليس عاماً
    final isPublicPath = ApiConstants.publicPaths.any(
      (path) => options.path.contains(path),
    );

    if (!isPublicPath) {
      final token = sharedPreferences.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    
    // إضافة headers أساسية
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // معالجة 401 Unauthorized
    if (err.response?.statusCode == 401) {
      // حذف التوكن المنتهي
      sharedPreferences.remove('auth_token');
      sharedPreferences.remove('user_data');
      
      // يمكن إضافة حدث لتوجيه المستخدم إلى صفحة تسجيل الدخول
      // عبر Stream أو Event Bus
    }
    handler.next(err);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // معالجة الأخطاء الشائعة
    String errorMessage = 'حدث خطأ غير متوقع';
    
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'انتهت مهلة الاتصال، يرجى المحاولة مرة أخرى';
        break;
      case DioExceptionType.connectionError:
        errorMessage = 'لا يوجد اتصال بالإنترنت';
        break;
      case DioExceptionType.badResponse:
        if (err.response?.data != null) {
          // محاولة استخراج رسالة الخطأ من الـ API
          try {
            final data = err.response?.data as Map<String, dynamic>;
            errorMessage = data['message'] ?? data['error'] ?? 'حدث خطأ في الخادم';
          } catch (e) {
            errorMessage = 'حدث خطأ في الخادم';
          }
        }
        break;
      default:
        errorMessage = err.message ?? 'حدث خطأ غير متوقع';
        break;
    }
    
    // إضافة رسالة الخطأ المخصصة إلى الـ response
    err.response?.data = {
      'message': errorMessage,
      'statusCode': err.response?.statusCode,
    };
    
    handler.next(err);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🌐 REQUEST: ${options.method} ${options.path}');
    print('📦 HEADERS: ${options.headers}');
    if (options.data != null) {
      print('📦 BODY: ${options.data}');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}');
    print('📦 DATA: ${response.data}');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('❌ ERROR: ${err.message}');
    print('📍 PATH: ${err.requestOptions.path}');
    if (err.response?.data != null) {
      print('📦 RESPONSE DATA: ${err.response?.data}');
    }
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    handler.next(err);
  }
}