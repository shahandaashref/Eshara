import '../entities/add_word_request.dart';

abstract class AddWordRepository {
  Future<void> submitWordRequest(AddWordRequest request);
}
