import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/translation_model.dart';
import 'package:flutter/foundation.dart';

abstract class SignRemoteDataSource {
  Future<TranslationModel> translateSign(String videoPath);
}

class SignRemoteDataSourceImpl implements SignRemoteDataSource {
  final http.Client client;

  SignRemoteDataSourceImpl({required this.client});

  @override
  Future<TranslationModel> translateSign(String videoPath) async {
    try {
      // 1. تحديد الرابط
      var uri = Uri.parse(
        'https://sign-to-text-production.up.railway.app/predict',
      );

      // 2. إنشاء طلب من نوع Multipart لرفع الملفات
      var request = http.MultipartRequest('POST', uri);

      // 3. إضافة ملف الفيديو للطلب (يقرأ الملف مباشرة من المسار)
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          videoPath,
        ), // 'file' هو الـ Key المطلوب في الـ API
      );

      // 4. إرسال الطلب للسيرفر واستقبال الرد كـ Stream
      // ضفنا Timeout دقيقتين عشان لو الفيديو مساحته كبيرة
      var streamedResponse = await client
          .send(request)
          .timeout(const Duration(minutes: 2));

      // 5. تحويل الـ Stream إلى Response عادي لسهولة قراءة البيانات
      var response = await http.Response.fromStream(streamedResponse);

      // طبعنا الرد في الكونسول عشان نشوف شكله إيه بالظبط
      debugPrint('================= SERVER RESPONSE =================');
      debugPrint(response.body);
      debugPrint('===================================================');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // تحويل النص لـ JSON ثم للمودل الخاص بك
        final jsonMap = json.decode(response.body);
        return TranslationModel.fromJson(jsonMap);
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
