import 'dart:convert';

import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';
import 'package:dio/dio.dart';

abstract class AdminRemoteDataSource {
  Future<List<AdminWord>> getWords({String? categoryId});
  Future<AdminWord> addWord(AdminWord word);
  Future<void> updateWord(AdminWord word);
  Future<void> deleteWord(String wordId);
  Future<List<AdminCategory>> getCategories();
  Future<AdminCategory> addCategory(String name);
  Future<void> deleteCategory(String categoryId);
  Future<List<WordRequest>> getWordRequests();
  Future<void> acceptRequest(String requestId);
  Future<void> rejectRequest(String requestId);
  Future<dynamic> getUsers();
}

/// Mock implementation — استبدل بـ HTTP calls حقيقية
class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final Dio dio;

  AdminRemoteDataSourceImpl({required this.dio});

  dynamic _unwrapResponse(dynamic response) {
    if (response is Map<String, dynamic>) {
      if (response.containsKey('data')) {
        return response['data'];
      }
      return response;
    }

    if (response is String) {
      try {
        final decoded = json.decode(response);
        if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
          return decoded['data'];
        }
        return decoded;
      } catch (_) {
        return response;
      }
    }

    return response;
  }

  List<dynamic> _normalizeList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map<String, dynamic> && data.containsKey('items')) {
      return data['items'] as List<dynamic>;
    }
    return [data];
  }

  @override
  Future<List<AdminWord>> getWords({String? categoryId}) async {
    try {
      final response = await dio.get('/api/admin/get-all-words');
      final data = _unwrapResponse(response.data);
      final items = _normalizeList(data);
      final words = items
          .map(
            (item) =>
                AdminWord.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();

      if (categoryId == null || categoryId.isEmpty) {
        return words;
      }

      return words.where((word) => word.categoryId == categoryId).toList();
    } on DioException catch (e) {
      throw Exception('فشل تحميل الكلمات: ${e.message}');
    }
  }

  @override
  Future<AdminWord> addWord(AdminWord word) async {
    try {
      // The videoUrl is expected to be a local file path
      final formData = FormData.fromMap({
        'ArabicMeaning': word.word,
        'Gloss': word.gloss,
        'Description': word.description,
        'CategoryId': word.categoryId,
        'LanguageVariant': 'EGY', // Assuming a default or passed value
        if (word.videoUrl != null && !word.videoUrl!.startsWith('http'))
          'VideoFile': await MultipartFile.fromFile(word.videoUrl!),
      });

      final response = await dio.post('/api/admin/add-word', data: formData);

      final data = _unwrapResponse(response.data);
      if (data is Map<String, dynamic>) {
        return AdminWord.fromJson(data);
      }
      // If response is not a word, we might need to refetch or handle it.
      // For now, returning the original word with a placeholder ID.
      return word.copyWith(id: DateTime.now().toIso8601String());
    } on DioException catch (e) {
      throw Exception('فشل إضافة الكلمة: ${e.message}');
    }
  }

  @override
  Future<void> updateWord(AdminWord word) async {
    try {
      await dio.put(
        '/api/admin/update-word/${word.id}',
        data: {
          'arabicMeaning': word.word,
          'gloss': word.gloss,
          'description': word.description,
          'isActive':
              true, // Assuming we always want to keep it active on update
        },
      );
    } on DioException catch (e) {
      throw Exception('فشل تعديل الكلمة: ${e.message}');
    }
  }

  @override
  Future<void> deleteWord(String wordId) async {
    // The API uses DELETE /api/admin/delete-word/{id}
    // The current implementation is correct.
    try {
      await dio.delete('/api/admin/delete-word/$wordId');
    } on DioException catch (e) {
      throw Exception('فشل حذف الكلمة: ${e.message}');
    }
  }

  @override
  Future<List<AdminCategory>> getCategories() async {
    try {
      final response = await dio.get('/api/admin/get-all-categories');
      final data = _unwrapResponse(response.data);
      final items = _normalizeList(data);
      final categories = items
          .map(
            (item) =>
                AdminCategory.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();

      return categories;
    } on DioException catch (e) {
      throw Exception('فشل تحميل الفئات: ${e.message}');
    }
  }

  @override
  Future<AdminCategory> addCategory(String name) async {
    try {
      final response = await dio.post(
        '/api/admin/categories',
        data: {
          'name': name,
          'description': 'Default description' /* API requires description */,
        },
      );
      final data = _unwrapResponse(response.data);
      if (data is Map<String, dynamic>) {
        return AdminCategory.fromJson(data);
      }
      return AdminCategory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        wordCount: 0,
      );
    } on DioException catch (e) {
      throw Exception('فشل إضافة الفئة: ${e.message}');
    }
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    // The API uses DELETE /api/admin/categories/{id}
    // The current implementation is correct.
    try {
      await dio.delete('/api/admin/categories/$categoryId');
    } on DioException catch (e) {
      throw Exception('فشل حذف الفئة: ${e.message}');
    }
  }

  @override
  Future<List<WordRequest>> getWordRequests() async {
    try {
      final response = await dio.get('/api/admin/word-requests');
      final data = _unwrapResponse(response.data);
      final items = _normalizeList(data);
      return items
          .map(
            (item) =>
                WordRequest.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
    } on DioException catch (e) {
      throw Exception('فشل تحميل طلبات الكلمات: ${e.message}');
    }
  }

  @override
  Future<void> acceptRequest(String requestId) async {
    try {
      // API requires a body, sending empty values for now.
      // This should be updated to send actual data from the UI.
      await dio.put(
        '/api/admin/word-requests/$requestId/approve',
        data: {
          "adminComment": "Approved",
          "gloss": "",
          "description": "",
          "categoryId": "",
        },
      );
    } on DioException catch (e) {
      throw Exception('فشل قبول الطلب: ${e.message}');
    }
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    try {
      // API requires a body, sending a comment.
      await dio.put(
        '/api/admin/word-requests/$requestId/reject',
        data: {
          "adminComment": "Rejected",
          "gloss": "",
          "description": "",
          "categoryId": "",
        },
      );
    } on DioException catch (e) {
      throw Exception('فشل رفض الطلب: ${e.message}');
    }
  }

  @override
  Future<dynamic> getUsers() async {
    try {
      final response = await dio.get('/api/admin/users');
      final data = _unwrapResponse(response.data);
      if (data is List) return data;
      if (data is Map<String, dynamic> && data.containsKey('items')) {
        return data['items'];
      }
      return data;
    } on DioException catch (_) {
      return <dynamic>[];
    }
  }
}
