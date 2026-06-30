import '../entities/sign_video.dart';
import '../repositories/text_to_sign_repository.dart';

/// [UseCase] — ConvertTextToSignUseCase
/// بتمثل عملية تحويل النص المكتوب إلى فيديو إشارة
/// الـ BLoC بيستخدمها مباشرة من غير ما يعرف حاجة عن الـ data layer
class ConvertTextToSignUseCase {
  final TextToSignRepository? repository;

  // جعلنا تمرير الـ Repository اختيارياً (مؤقتاً) لتخطي مشكلة GetIt
  ConvertTextToSignUseCase([this.repository]);

  /// [call] — بتاخد [text] وبترجع [SignVideo]
  Future<SignVideo> call(String text) {
    if (repository == null) {
      // لو مفيش Repository، هنرمي Exception عشان الـ Bloc يمسكه ويعرض الـ Error State في التصميم
      throw Exception('Repository is not injected yet.');
    }
    return repository!.convertTextToSign(text);
  }
}
