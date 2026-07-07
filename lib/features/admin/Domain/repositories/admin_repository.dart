import 'package:eshara/features/admin/domain/entities/admin_entities.dart';

/// [Repository Contract] — AdminRepository
abstract interface class AdminRepository {
  // ── Words ─────────────────────────────────────────────────────────────────
  Future<List<AdminWord>> getWords({String? categoryId});
  Future<AdminWord> addWord(AdminWord word);
  Future<void> updateWord(AdminWord word);
  Future<void> deleteWord(String wordId);

  // ── Categories ────────────────────────────────────────────────────────────
  Future<List<AdminCategory>> getCategories();
  Future<AdminCategory> addCategory(String name);
  Future<void> deleteCategory(String categoryId);

  // ── Requests ──────────────────────────────────────────────────────────────
  Future<List<WordRequest>> getWordRequests();
  Future<void> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);

  // ── Users ─────────────────────────────────────────────────────────────────
  Future<dynamic> getUsers();
}
