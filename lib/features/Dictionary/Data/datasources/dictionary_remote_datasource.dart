import 'package:dio/dio.dart';
import 'package:eshara/features/Dictionary/Data/models/category_model.dart';
import 'package:eshara/features/Dictionary/Data/models/sign_model.dart';

abstract class DictionaryRemoteDataSource {
  /// بيجيب كل الفئات النشطة
  Future<List<CategoryModel>> getCategories();

  /// بيجيب كلمات فئة معينة
  Future<List<SignModel>> getWordsByCategory(String categoryId);

  /// بيبحث عن الكلمات
  Future<List<SignModel>> searchSigns(String query);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  final Dio dio;

  DictionaryRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get('/api/categories?includeInactive=false');
      return (response.data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('فشل تحميل الفئات: ${e.message}');
    }
  }

  @override
  Future<List<SignModel>> getWordsByCategory(String categoryId) async {
    try {
      final response = await dio.get(
        '/api/categories/$categoryId/words?includeInactive=false',
      );
      return (response.data as List)
          .map((json) => SignModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('فشل تحميل الكلمات: ${e.message}');
    }
  }

  @override
  Future<List<SignModel>> searchSigns(String query) async {
    try {
      // ✅ لو الـ API عنده search endpoint استخدمه
      // لو مفيش، هنبحث محلياً بعد ما نجيب كل الكلمات
      final response = await dio.get(
        '/api/words/search', // غيّر ده لو الـ endpoint مختلف
        queryParameters: {'query': query},
      );
      return (response.data as List)
          .map((json) => SignModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      // لو مفيش search endpoint، نرجع empty list
      print('⚠️ Search API not available: ${e.message}');
      return [];
    }
  }
}