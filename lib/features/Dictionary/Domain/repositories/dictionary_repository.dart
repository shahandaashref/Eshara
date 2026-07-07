import 'package:eshara/features/Dictionary/domain/entities/sign_entity.dart';
import 'package:eshara/features/Dictionary/domain/entities/category_entity.dart';

abstract class DictionaryRepository {
  Future<List<CategoryEntity>> getCategories();
  Future<List<SignEntity>> getWordsByCategory(String categoryId);
  Future<List<SignEntity>> searchSigns(String query);
}