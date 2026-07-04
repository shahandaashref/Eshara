import 'dart:convert';

import 'package:eshara/features/admin/Domain/entitys/admin_entities.dart';
import 'package:dio/dio.dart';

abstract class AdminRemoteDataSource {
  Future<List<AdminWord>> getWords({String? categoryId});
  Future<AdminWord> addWord(AdminWord word);
  Future<void> updateWord(AdminWord word);
  Future<void> deleteWord(String wordId);
  Future<List<AdminCategory>> getCategories();
  Future<AdminCategory> addCategory(String name, String? description);
  Future<void> updateCategory(AdminCategory category);
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

  Options _allowAnyStatus() => Options(validateStatus: (_) => true);

  List<dynamic> _normalizeList(dynamic data) {
    if (data == null) return [];
    if (data is List) return data;
    if (data is Map<String, dynamic> && data.containsKey('items')) {
      return data['items'] as List<dynamic>;
    }
    return [data];
  }

  List<Map<String, dynamic>> _toJsonList(dynamic data) {
    final items = _normalizeList(data);
    return items
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  @override
  Future<List<AdminWord>> getWords({String? categoryId}) async {
    try {
      final response = await dio.get(
        '/api/admin/get-all-words',
        queryParameters: {
          if (categoryId != null && categoryId.isNotEmpty)
            'categoryId': categoryId,
        },
      );
      final data = _unwrapResponse(response.data);
      final items = _normalizeList(data);
      return items
          .map(
            (item) =>
                AdminWord.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();
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
      // 1. جلب كل الفئات وكل الكلمات في طلبات متوازية لتحسين الأداء
      final responses = await Future.wait([
        dio.get('/api/categories'),
        dio.get(
          '/api/admin/get-all-words',
          queryParameters: {'includeInactive': true},
        ),
      ]);

      // 2. معالجة استجابة الفئات
      final categoriesResponse = responses[0];
      final categoriesData = _unwrapResponse(categoriesResponse.data);
      final categoryItems = _normalizeList(categoriesData);
      final categories = categoryItems
          .map(
            (item) =>
                AdminCategory.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();

      // 3. معالجة استجابة الكلمات وحساب عددها لكل فئة
      final wordsResponse = responses[1];
      final wordsData = _unwrapResponse(wordsResponse.data);
      final wordItems = _normalizeList(wordsData);
      final words = wordItems
          .map(
            (item) =>
                AdminWord.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList();

      final wordCounts = <String, int>{};
      for (final word in words) {
        // التأكد من أن categoryId ليس null قبل استخدامه
        if (word.categoryId != null && word.categoryId!.isNotEmpty) {
          wordCounts.update(
            word.categoryId!,
            (value) => value + 1,
            ifAbsent: () => 1,
          );
        }
      }

      // 4. تحديث كل فئة بعدد الكلمات الصحيح
      return categories
          .map((cat) => cat.copyWith(wordCount: wordCounts[cat.id] ?? 0))
          .toList();
    } on DioException catch (e) {
      throw Exception('فشل تحميل الفئات: ${e.message}');
    }
  }

  @override
  Future<AdminCategory> addCategory(String name, String? description) async {
    try {
      final response = await dio.post(
        '/api/admin/categories', // Endpoint صحيح حسب التوثيق
        data: {'name': name, 'description': description ?? ''},
      );
      final data = _unwrapResponse(response.data);
      // إذا كانت الاستجابة تحتوي على بيانات الفئة الجديدة، قم بتحويلها
      if (data is Map<String, dynamic>) {
        // نقوم بإضافة wordCount: 0 بشكل يدوي لضمان التوافقية
        return AdminCategory.fromJson({...data, 'wordCount': 0});
      }
      // إذا لم ترجع الاستجابة بيانات الفئة، فهذا يعتبر خطأ
      throw Exception(
        'فشل إضافة الفئة: لم يتم استلام بيانات الفئة الجديدة من الخادم.',
      );
    } on DioException catch (e) {
      // محاولة استخراج رسالة خطأ واضحة من الـ API
      final errorData = e.response?.data;
      if (errorData is Map<String, dynamic> &&
          errorData.containsKey('message')) {
        throw Exception('فشل إضافة الفئة: ${errorData['message']}');
      }
      throw Exception('فشل إضافة الفئة: ${e.message ?? 'خطأ غير معروف'}');
    }
  }

  @override
  Future<void> updateCategory(AdminCategory category) async {
    try {
      await dio.put(
        '/api/admin/categories/${category.id}',
        data: {
          'name': category.name,
          'description': category.description,
          'isActive':
              true, // Assuming we always want to keep it active on update
        },
      );
    } on DioException catch (e) {
      // You can parse the error from e.response.data if needed
      throw Exception('فشل تعديل الفئة: ${e.message}');
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
    // حسب التوثيق، يمكننا التحكم في الطلبات التي يتم جلبها
    // هنا سنجلب الطلبات المعلقة فقط بشكل افتراضي
    try {
      final response = await dio.get(
        '/api/admin/word-requests',
        queryParameters: {
          'includePending': true,
          'includeApproved': false,
          'includeRejected': false,
        },
      );
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
      // ملاحظة: الـ API يتطلب body. حالياً يتم إرسال قيم افتراضية.
      // يجب تحديث هذه الدالة لاحقاً لتمرير البيانات من الواجهة الرسومية.
      await dio.put(
        '/api/admin/word-requests/$requestId/approve',
        data: {
          "adminComment": "Approved",
          "gloss": "Default Gloss", // قيمة افتراضية مؤقتة
          "description": "Default Description", // قيمة افتراضية مؤقتة
          "categoryId":
              "00000000-0000-0000-0000-000000000000", // UUID افتراضي مؤقت
        },
      );
    } on DioException catch (e) {
      throw Exception('فشل قبول الطلب: ${e.message}');
    }
  }

  @override
  Future<void> rejectRequest(String requestId) async {
    try {
      // ملاحظة: الـ API يتطلب body. حالياً يتم إرسال قيم افتراضية.
      await dio.put(
        '/api/admin/word-requests/$requestId/reject',
        data: {"adminComment": "Rejected"},
      );
    } on DioException catch (e) {
      throw Exception('فشل رفض الطلب: ${e.message}');
    }
  }

  @override
  Future<dynamic> getUsers() async {
    try {
      final response = await dio.get(
        '/api/admin/get-all-users',
      ); // تم تعديل الـ Endpoint
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
