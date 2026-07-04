import 'package:dio/dio.dart';
import 'package:eshara/features/Profile/Domain/entities/profile_entity.dart';
import '../models/profile_model.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile();
  Future<void> updateProfile(ProfileEntity profile);
  Future<void> logout();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  ProfileRemoteDataSourceImpl({required this.dio});

  @override
  Future<ProfileModel> getProfile() async {
    try {
      final response = await dio.get('/api/User/profile');

      // جعل الكود أكثر مرونة للتعامل مع أشكال مختلفة من الاستجابة
      Map<String, dynamic>? data;
      if (response.data is Map<String, dynamic>) {
        if (response.data.containsKey('data') &&
            response.data['data'] is Map<String, dynamic>) {
          data = response.data['data'] as Map<String, dynamic>;
        } else {
          data = response
              .data; // التعامل مع الحالة التي تكون فيها البيانات هي الاستجابة نفسها
        }
      }

      if (data == null) {
        throw Exception('فشلت العملية: الخادم لم يرجع بيانات صالحة.');
      }

      return ProfileModel.fromJson(data);
    } on DioException catch (e) {
      throw Exception('Failed to load profile: ${e.message}');
    }
  }

  @override
  Future<void> updateProfile(ProfileEntity profile) async {
    try {
      // افترض أن الـ API يتوقع هذا الشكل من البيانات
      await dio.put(
        '/api/User/profile',
        data: {'fullName': profile.fullName, 'email': profile.email},
      );
    } on DioException catch (e) {
      throw Exception('Failed to update profile: ${e.message}');
    }
  }

  @override
  Future<void> logout() async {
    // هنا يمكنك استدعاء API لتسجيل الخروج إذا كان موجوداً
    // أو يمكنك فقط حذف التوكن من التخزين المحلي
    // await dio.post('/api/Auth/logout');
  }
}
