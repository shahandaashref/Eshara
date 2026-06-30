import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';
import 'package:eshara/features/admin/Domain/repositorys/admin_repository.dart';

import '../datasources/admin_remote_datasource.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;
  AdminRepositoryImpl({required this.remoteDataSource});

  @override Future<AdminStats> getStats() => remoteDataSource.getStats();
  @override Future<List<AdminWord>> getWords({String? categoryId}) => remoteDataSource.getWords(categoryId: categoryId);
  @override Future<AdminWord> addWord(AdminWord word) => remoteDataSource.addWord(word);
  @override Future<AdminWord> updateWord(AdminWord word) => remoteDataSource.updateWord(word);
  @override Future<void> deleteWord(String wordId) => remoteDataSource.deleteWord(wordId);
  @override Future<List<AdminCategory>> getCategories() => remoteDataSource.getCategories();
  @override Future<AdminCategory> addCategory(String name) => remoteDataSource.addCategory(name);
  @override Future<void> deleteCategory(String categoryId) => remoteDataSource.deleteCategory(categoryId);
  @override Future<List<WordRequest>> getWordRequests() => remoteDataSource.getWordRequests();
  @override Future<void> acceptRequest(String requestId) => remoteDataSource.acceptRequest(requestId);
  @override Future<void> rejectRequest(String requestId) => remoteDataSource.rejectRequest(requestId);
}
