import 'package:eshara/features/Dictionary/domain/entities/category_entity.dart';
import 'package:eshara/features/Dictionary/domain/repositories/dictionary_repository.dart';

class GetCategoriesUseCase {
  final DictionaryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() async {
    return await repository.getCategories();
  }
}