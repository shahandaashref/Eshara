import 'package:dio/dio.dart';
import '../models/sign_video_model.dart';

/// [DataSource Contract] — TextToSignRemoteDataSource
abstract class TextToSignRemoteDataSource {
  Future<SignVideoModel> convertTextToSign(String text);
}

/// [DataSource Implementation] — TextToSignRemoteDataSourceImpl
/// بيستخدم API الجديد: POST /translate
class TextToSignRemoteDataSourceImpl implements TextToSignRemoteDataSource {
  final Dio dio;

  TextToSignRemoteDataSourceImpl({required this.dio});

  /// [convertTextToSign] — بتبعت النص للـ API ويرجع رابط الأفاتار
  @override
  Future<SignVideoModel> convertTextToSign(String text) async {
    try {
      final response = await dio.post(
        '/translate',
        data: {
          'input_type': 'text',
          'content': text,
          'simplify_with_gemini': true,
          'avatar': 'marc', // ممكن تخليها قابلة للتغيير بعدين
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return SignVideoModel.fromJson(response.data);
      }
      
      throw Exception('فشل تحويل النص إلى إشارة');
    } on DioException catch (e) {
      throw Exception('فشل تحويل النص: ${e.message}');
    }
  }
}