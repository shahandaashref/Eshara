import 'package:eshara/features/Dictionary/Data/datasources/dictionary_remote_datasource.dart';
import 'package:eshara/features/Dictionary/domain/entities/category_entity.dart';
import 'package:eshara/features/Dictionary/domain/entities/sign_entity.dart';
import 'package:eshara/features/Dictionary/domain/repositories/dictionary_repository.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryRemoteDataSource remoteDataSource;

  DictionaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await remoteDataSource.getCategories();
  }

  @override
  Future<List<SignEntity>> getWordsByCategory(String categoryId) async {
    return await remoteDataSource.getWordsByCategory(categoryId);
  }

  @override
  Future<List<SignEntity>> searchSigns(String query) async {
    return await remoteDataSource.searchSigns(query);
  }
}