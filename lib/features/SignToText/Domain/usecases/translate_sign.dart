import '../entities/translation.dart';
import '../repositories/sign_repository.dart';

class TranslateSignUseCase {
  final SignRepository repository;

  TranslateSignUseCase(this.repository);

  Future<Translation> call(String videoPath) {
    return repository.translateSign(videoPath);
  }
}
