import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';
import 'package:eshara/features/admin/Domain/repositorys/admin_repository.dart';


class GetStatsUseCase {
  final AdminRepository repo;
  GetStatsUseCase(this.repo);
  Future<AdminStats> call() => repo.getStats();
}

class GetWordsUseCase {
  final AdminRepository repo;
  GetWordsUseCase(this.repo);
  Future<List<AdminWord>> call({String? categoryId}) =>
      repo.getWords(categoryId: categoryId);
}

class AddWordUseCase {
  final AdminRepository repo;
  AddWordUseCase(this.repo);
  Future<AdminWord> call(AdminWord word) => repo.addWord(word);
}

class UpdateWordUseCase {
  final AdminRepository repo;
  UpdateWordUseCase(this.repo);
  Future<AdminWord> call(AdminWord word) => repo.updateWord(word);
}

class DeleteWordUseCase {
  final AdminRepository repo;
  DeleteWordUseCase(this.repo);
  Future<void> call(String wordId) => repo.deleteWord(wordId);
}

class GetCategoriesUseCase {
  final AdminRepository repo;
  GetCategoriesUseCase(this.repo);
  Future<List<AdminCategory>> call() => repo.getCategories();
}

class AddCategoryUseCase {
  final AdminRepository repo;
  AddCategoryUseCase(this.repo);
  Future<AdminCategory> call(String name) => repo.addCategory(name);
}

class DeleteCategoryUseCase {
  final AdminRepository repo;
  DeleteCategoryUseCase(this.repo);
  Future<void> call(String categoryId) => repo.deleteCategory(categoryId);
}

class GetWordRequestsUseCase {
  final AdminRepository repo;
  GetWordRequestsUseCase(this.repo);
  Future<List<WordRequest>> call() => repo.getWordRequests();
}

class AcceptRequestUseCase {
  final AdminRepository repo;
  AcceptRequestUseCase(this.repo);
  Future<void> call(String requestId) => repo.acceptRequest(requestId);
}

class RejectRequestUseCase {
  final AdminRepository repo;
  RejectRequestUseCase(this.repo);
  Future<void> call(String requestId) => repo.rejectRequest(requestId);
}
