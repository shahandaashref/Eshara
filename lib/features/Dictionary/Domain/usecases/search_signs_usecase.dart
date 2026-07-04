import '../entities/sign_entity.dart';
import '../repositories/dictionary_repository.dart';

class SearchSignsUseCase {
  final DictionaryRepository repository;

  SearchSignsUseCase(this.repository);

  Future<List<SignEntity>> call(String query) async {
    return await repository.searchSigns(query);
  }
}
