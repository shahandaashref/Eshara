import '../entities/translation.dart';

/// [Repository Contract] — SignRepository
/// ده الـ abstract interface اللي بيحدد إيه العمليات المتاحة.
/// الـ domain layer بتتعامل معاه بس — ومش عارفة أي حاجة عن الـ implementation.
/// الـ implementation الحقيقية موجودة في data/repositories/sign_repo_impl.dart
abstract interface class SignRepository {

  /// بتاخد [videoPath] مسار الفيديو المسجل
  /// وبترجع [Translation] فيها النص المترجم
  Future<Translation> translateSign(String videoPath);
}