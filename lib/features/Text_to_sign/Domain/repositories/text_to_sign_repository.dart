import '../entities/sign_video.dart';

abstract class TextToSignRepository {
  Future<SignVideo> convertTextToSign(String text);
}
