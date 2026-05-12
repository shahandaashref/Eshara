import '../models/sign_video_model.dart';

/// [DataSource Contract] — TextToSignRemoteDataSource
abstract class TextToSignRemoteDataSource {
  Future<SignVideoModel> convertTextToSign(String text);
}

/// [DataSource Implementation] — TextToSignRemoteDataSourceImpl
/// دلوقتي بترجع mock data — استبدلها بـ HTTP call للـ AI model
class TextToSignRemoteDataSourceImpl implements TextToSignRemoteDataSource {

  /// [convertTextToSign] — بتبعت النص للـ AI ويرجع رابط الفيديو
  /// TODO: استبدل بـ POST /api/text-to-sign
  @override
  Future<SignVideoModel> convertTextToSign(String text) async {
    // بتحاكي وقت معالجة الـ AI
    await Future.delayed(const Duration(seconds: 3));

    return SignVideoModel(
      inputText: text,
      videoUrl: 'https://mock.api/videos/sign_output.mp4',
      createdAt: DateTime.now(),
    );
  }
}
