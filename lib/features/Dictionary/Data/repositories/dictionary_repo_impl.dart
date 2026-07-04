import 'package:eshara/features/Dictionary/Data/datasources/dictionary_remote_datasource.dart';
import 'package:eshara/features/Dictionary/Domain/entities/sign_entity.dart';
import 'package:eshara/features/Dictionary/Domain/repositories/dictionary_repository.dart';

class DictionaryRepositoryImpl implements DictionaryRepository {
  final DictionaryRemoteDataSource remoteDataSource;

  DictionaryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SignEntity>> getSignsByCategory(String category) async {
    try {
      return await remoteDataSource.getSignsByCategory(category);
    } catch (e) {
      // إعادة رمي الاستثناء لطبقة الـ BLoC للتعامل معه
      rethrow;
    }
  }

  @override
  Future<List<SignEntity>> searchSigns(String query) async {
    try {
      return await remoteDataSource.searchSigns(query);
    } catch (e) {
      rethrow;
    }
  }
}
