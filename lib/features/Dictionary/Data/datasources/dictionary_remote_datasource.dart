import 'package:dio/dio.dart';
import 'package:eshara/features/Dictionary/Data/models/category_model.dart';
import '../models/sign_model.dart';

abstract class DictionaryRemoteDataSource {
  /// بيجيب قائمة الفيديوهات بناءً على التصنيف (تحيات، عائلة، إلخ)
  Future<List<SignModel>> getSignsByCategory(String category);

  /// بيجيب كل الفئات النشطة
  Future<List<CategoryModel>> getCategories();

  /// بيبحث عن الفيديوهات بناءً على نص البحث
  Future<List<SignModel>> searchSigns(String query);
}

class DictionaryRemoteDataSourceImpl implements DictionaryRemoteDataSource {
  final Dio dio;

  // (Cache) متغير لتخزين البيانات محلياً عشان ما نعملش Request مع كل فلتر
  List<SignModel>? _cachedSigns;

  DictionaryRemoteDataSourceImpl({required this.dio});

  // دالة مساعدة بتجيب كل الكلمات من الباك إند مرة واحدة وتحفظها
  Future<List<SignModel>> _fetchAllSigns() async {
    // لو البيانات متحملة قبل كده، هنرجعها فوراً ومش هنكلم الباك إند تاني
    if (_cachedSigns != null) return _cachedSigns!;

    try {
      final response = await dio.get(
        'https://eshara.runasp.net/api/words', // تم تحديث الرابط
      );
      _cachedSigns = (response.data as List)
          .map((json) => SignModel.fromJson(json))
          .toList();
      return _cachedSigns!;
    } on DioException catch (e) {
      throw Exception('فشل تحميل القائمة: ${e.message}');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع');
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dio.get(
        'https://eshara.runasp.net/api/categories?includeInactive=false',
      );
      return (response.data as List)
          .map((json) => CategoryModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception('فشل تحميل الفئات: ${e.message}');
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء جلب الفئات');
    }
  }

  @override
  Future<List<SignModel>> getSignsByCategory(String category) async {
    final allSigns = await _fetchAllSigns();

    if (category == 'الكل') return allSigns;

    // الفلترة محلياً (تأكد من إن الخاصية اسمها category في SignModel)
    return allSigns.where((sign) => sign.category == category).toList();
  }

  @override
  Future<List<SignModel>> searchSigns(String query) async {
    final allSigns = await _fetchAllSigns();

    if (query.trim().isEmpty) return allSigns;

    // الفلترة محلياً (تأكد من إن الخاصية اسمها word في SignModel)
    return allSigns.where((sign) => sign.title.contains(query)).toList();
  }
}
