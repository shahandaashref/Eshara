import 'package:dio/dio.dart';
import '../models/sign_model.dart';

abstract class DictionaryRemoteDataSource {
  /// بيجيب قائمة الفيديوهات بناءً على التصنيف (تحيات، عائلة، إلخ)
  Future<List<SignModel>> getSignsByCategory(String category);

  /// بيبحث عن الفيديوهات بناءً على نص البحث
  Future<List<SignModel>> searchSigns(String query);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  final Dio dio;

  DictionaryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SignModel>> getSignsByCategory(String category) async {
    try {
      // ملحوظة: استبدلي الرابط برابط الـ API الحقيقي بتاع مشروع SignAvatars
      final response = await dio.get(
        'https://api.eshara.com/signs',
        queryParameters: {'category': category},
      );

      // Dio throws an exception for non-2xx status codes by default
      return (response.data as List)
          .map((json) => SignModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      // يمكنك التعامل مع أنواع الأخطاء المختلفة هنا (مثل الاتصال، الوقت المستقطع، إلخ)
      throw Exception('فشل تحميل القائمة: ${e.message}');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  @override
  Future<List<SignModel>> searchSigns(String query) async {
    try {
      final response = await dio.get(
        'https://api.eshara.com/signs/search',
        queryParameters: {'q': query},
      );

      return (response.data as List)
          .map((json) => SignModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('فشل البحث: ${e.message}');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }
}
