import '../entities/sign_video.dart';

/// [Repository Contract] — TextToSignRepository
/// بيحدد عملية تحويل النص إلى فيديو إشارة
abstract interface class TextToSignRepository {
  /// بتاخد [text] النص المكتوب
  /// وبترجع [SignVideo] فيه رابط الفيديو المولّد
  Future<SignVideo> convertTextToSign(String text);
}
