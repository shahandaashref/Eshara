import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/translation_model.dart';
import 'package:flutter/foundation.dart';

abstract class SignRemoteDataSource {
  Future<TranslationModel> translateSign(String videoPath);
}

class SignRemoteDataSourceImpl implements SignRemoteDataSource {
  final Dio dio;

  SignRemoteDataSourceImpl({required this.dio, required Object client});

  @override
  Future<TranslationModel> translateSign(String videoPath) async {
    try {
      // 1. إنشاء FormData لرفع الملف
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          videoPath,
          filename: videoPath.split('/').last,
        ),
      });

      // 2. إرسال الطلب باستخدام Dio
      final response = await dio.post(
        'https://sign-to-text-production.up.railway.app/predict',
        data: formData,
        options: Options(
          // Dio يستخدم milliseconds, الدقيقتان = 120000ms
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 2),
        ),
      );

      debugPrint('================= SERVER RESPONSE =================');
      debugPrint(json.encode(response.data));
      debugPrint('===================================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Dio يقوم بتحويل الـ JSON تلقائياً
        return TranslationModel.fromJson(response.data);
      } else {
        throw Exception(
          "فشل في تحليل الفيديو من السيرفر: كود ${response.statusCode}",
        );
      }
    } catch (e) {
      throw Exception('حدث خطأ أثناء رفع الفيديو: $e');
    }
  }
}
