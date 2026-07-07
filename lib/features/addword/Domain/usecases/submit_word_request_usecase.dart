

import 'package:eshara/features/addword/domain/entities/add_word_request.dart';
import 'package:eshara/features/addword/domain/repositories/add_word_repository.dart';

class SubmitWordRequestUseCase {
  final AddWordRepository repository;
  SubmitWordRequestUseCase(this.repository);

  Future<void> call(AddWordRequest request) {
    return repository.submitWordRequest(request);
  }
}
