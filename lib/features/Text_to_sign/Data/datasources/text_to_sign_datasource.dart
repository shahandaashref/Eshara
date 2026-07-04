import 'package:dio/dio.dart';
import '../models/sign_video_model.dart';

/// [DataSource Contract] — TextToSignRemoteDataSource
abstract class TextToSignRemoteDataSource {
  Future<SignVideoModel> convertTextToSign(String text);
}

/// [DataSource Implementation] — TextToSignRemoteDataSourceImpl
/// تم تحديثها لتستخدم استدعاء HTTP حقيقي
class TextToSignRemoteDataSourceImpl implements TextToSignRemoteDataSource {
  final Dio dio;

  TextToSignRemoteDataSourceImpl({required this.dio});

  /// [convertTextToSign] — بتبعت النص للـ AI ويرجع رابط الفيديو
  @override
  Future<SignVideoModel> convertTextToSign(String text) async {
    try {
      final response = await dio.post(
        '/api/Translation/text-to-sign',
        data: {'text': text},
      );
      if (response.data != null && response.data['success'] == true) {
        return SignVideoModel(
          inputText: text,
          videoUrl: response.data['videoUrl'],
          createdAt: DateTime.now(),
        );
      }
      throw Exception(response.data['message'] ?? 'فشل تحويل النص إلى إشارة');
    } on DioException catch (e) {
      throw Exception('فشل تحويل النص: ${e.message}');
    }
  }
}
