import '../entities/add_word_request.dart';
import '../repositories/add_word_repository.dart';

class SubmitWordRequestUseCase {
  final AddWordRepository repository;
  SubmitWordRequestUseCase(this.repository);

  Future<void> call(AddWordRequest request) {
    return repository.submitWordRequest(request);
  }
}
