import '../entities/sign_video.dart';
import '../repositories/text_to_sign_repository.dart';

/// [UseCase] — ConvertTextToSignUseCase
/// بتمثل عملية تحويل النص المكتوب إلى فيديو إشارة
/// الـ BLoC بيستخدمها مباشرة من غير ما يعرف حاجة عن الـ data layer
class ConvertTextToSignUseCase {
  final TextToSignRepository repository;

  ConvertTextToSignUseCase(this.repository);

  /// [call] — بتاخد [text] وبترجع [SignVideo]
  Future<SignVideo> call(String text) {
    // الآن يمكننا استدعاء الـ repository مباشرة بثقة
    return repository.convertTextToSign(text);
  }
}
