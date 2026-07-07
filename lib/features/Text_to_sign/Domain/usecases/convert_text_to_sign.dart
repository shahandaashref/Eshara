import '../entities/sign_video.dart';
import '../repositories/text_to_sign_repository.dart';

/// [UseCase] — ConvertTextToSignUseCase
class ConvertTextToSignUseCase {
  final TextToSignRepository repository;

  ConvertTextToSignUseCase(this.repository);

  Future<SignVideo> call(String text) {
    return repository.convertTextToSign(text);
  }
}