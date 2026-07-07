import 'package:dio/dio.dart';
import 'package:eshara/features/addword/domain/entities/add_word_request.dart';

abstract class AddWordRemoteDataSource {
  Future<void> submitWordRequest(AddWordRequest request);
}

class AddWordRemoteDataSourceImpl implements AddWordRemoteDataSource {
  final Dio dio;
  static const String baseUrl = 'https://eshara.runasp.net';

  AddWordRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> submitWordRequest(AddWordRequest request) async {
    try {
      final formData = FormData();
      formData.fields.addAll([
        MapEntry('ArabicMeaning', request.arabicMeaning),
        MapEntry('Notes', request.notes),
      ]);

      if (request.videoPath != null && request.videoPath!.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'VideoFile',
            await MultipartFile.fromFile(
              request.videoPath!,
              filename: 'video.mp4',
            ),
          ),
        );
      }

      await dio.post(
        '$baseUrl/api/word-requests',
        data: formData,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
    } on DioException catch (e) {
      throw Exception('فشل إرسال الطلب: ${e.message}');
    } catch (e) {
      throw Exception('حدث خطأ أثناء إرسال الطلب');
    }
  }
}
