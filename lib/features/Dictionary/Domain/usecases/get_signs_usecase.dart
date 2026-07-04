import '../entities/sign_entity.dart';
import '../repositories/dictionary_repository.dart';

class GetSignsUseCase {
  final DictionaryRepository repository;

  GetSignsUseCase(this.repository);

  Future<List<SignEntity>> call(String category) async {
    return await repository.getSignsByCategory(category);
  }
}