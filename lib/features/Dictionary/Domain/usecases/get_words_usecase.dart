import 'package:eshara/features/Dictionary/domain/entities/sign_entity.dart';
import 'package:eshara/features/Dictionary/domain/repositories/dictionary_repository.dart';

class GetWordsUseCase {
  final DictionaryRepository repository;

  GetWordsUseCase(this.repository);

  Future<List<SignEntity>> call({required String categoryId}) async {
    return await repository.getWordsByCategory(categoryId);
  }
}