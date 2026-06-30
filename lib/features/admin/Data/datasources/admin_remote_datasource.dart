import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';

abstract class AdminRemoteDataSource {
  Future<AdminStats> getStats();
  Future<List<AdminWord>> getWords({String? categoryId});
  Future<AdminWord> addWord(AdminWord word);
  Future<AdminWord> updateWord(AdminWord word);
  Future<void> deleteWord(String wordId);
  Future<List<AdminCategory>> getCategories();
  Future<AdminCategory> addCategory(String name);
  Future<void> deleteCategory(String categoryId);
  Future<List<WordRequest>> getWordRequests();
  Future<void> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);
}

/// Mock implementation — استبدل بـ HTTP calls حقيقية
class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  @override
  Future<AdminStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AdminStats(totalUsers: 12, totalWords: 12650, pendingRequests: 3);
  }

  @override
  Future<List<AdminWord>> getWords({String? categoryId}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      AdminWord(id: '1', word: 'مرحبا', category: 'تحيات', createdAt: DateTime.now()),
      AdminWord(id: '2', word: 'شكرا', category: 'تحيات', createdAt: DateTime.now()),
      AdminWord(id: '3', word: 'حاسوب', category: 'تعليم', createdAt: DateTime.now()),
      AdminWord(id: '4', word: 'مدرسة', category: 'تعليم', createdAt: DateTime.now()),
      AdminWord(id: '5', word: 'أب', category: 'عائلة', createdAt: DateTime.now()),
      AdminWord(id: '6', word: 'أم', category: 'عائلة', createdAt: DateTime.now()),
    ];
  }

  @override
  Future<AdminWord> addWord(AdminWord word) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return word;
  }

  @override
  Future<AdminWord> updateWord(AdminWord word) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return word;
  }

  @override
  Future<void> deleteWord(String wordId) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<List<AdminCategory>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      AdminCategory(id: '1', name: 'تحيات', wordCount: 12),
      AdminCategory(id: '2', name: 'عائلة', wordCount: 8),
      AdminCategory(id: '3', name: 'تعليم', wordCount: 20),
      AdminCategory(id: '4', name: 'طبية', wordCount: 15),
      AdminCategory(id: '5', name: 'الكل', wordCount: 55),
    ];
  }

  @override
  Future<AdminCategory> addCategory(String name) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return AdminCategory(id: DateTime.now().millisecondsSinceEpoch.toString(), name: name, wordCount: 0);
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<List<WordRequest>> getWordRequests() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return [
      WordRequest(
        id: '1',
        word: 'مستشفى',
        userName: 'أميرة عبدالوهاب',
        userEmail: 'amira@gmail.com',
        status: WordRequestStatus.pending,
        createdAt: DateTime.now(),
      ),
      WordRequest(
        id: '2',
        word: 'دواء',
        userName: 'محمد أحمد',
        userEmail: 'mohamed@gmail.com',
        status: WordRequestStatus.pending,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void> acceptRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 400));
  }
}
