import 'package:eshara/features/admin/Domain/repositories/admin_repository.dart';

import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';

class GetWordsUseCase {
  final AdminRepository repository;
  GetWordsUseCase(this.repository);
  Future<dynamic> call({String? categoryId}) async =>
      repository.getWords(categoryId: categoryId);
}

class AddWordUseCase {
  final AdminRepository repository;
  AddWordUseCase(this.repository);
  Future<void> call(dynamic word) async => repository.addWord(word);
}

class UpdateWordUseCase {
  final AdminRepository repository;
  UpdateWordUseCase(this.repository);
  Future<void> call(dynamic word) async => repository.updateWord(word);
}

class DeleteWordUseCase {
  final AdminRepository repository;
  DeleteWordUseCase(this.repository);
  Future<void> call(String wordId) async => repository.deleteWord(wordId);
}

class GetCategoriesUseCase {
  final AdminRepository repository;
  GetCategoriesUseCase(this.repository);
  Future<dynamic> call() async => repository.getCategories();
}

class AddCategoryUseCase {
  final AdminRepository repository;
  AddCategoryUseCase(this.repository);
  Future<AdminCategory> call({
    required String name,
    String? description,
  }) async => repository.addCategory(name,);
}

class DeleteCategoryUseCase {
  final AdminRepository repository;
  DeleteCategoryUseCase(this.repository);
  Future<void> call(String categoryId) async =>
      repository.deleteCategory(categoryId);
}

class GetWordRequestsUseCase {
  final AdminRepository repository;
  GetWordRequestsUseCase(this.repository);
  Future<dynamic> call() async => repository.getWordRequests();
}

class AcceptRequestUseCase {
  final AdminRepository repository;
  AcceptRequestUseCase(this.repository);
  Future<void> call(String requestId) async =>
      repository.acceptRequest(requestId);
}

class RejectRequestUseCase {
  final AdminRepository repository;
  RejectRequestUseCase(this.repository);
  Future<void> call(String requestId) async =>
      repository.rejectRequest(requestId);
}

class GetUsersUseCase {
  final AdminRepository repository;
  GetUsersUseCase(this.repository);
  Future<dynamic> call() async => repository.getUsers();
}
