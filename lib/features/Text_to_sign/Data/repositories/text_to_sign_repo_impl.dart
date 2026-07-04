import '../../domain/entities/sign_video.dart';
import '../../domain/repositories/text_to_sign_repository.dart';
import '../datasources/text_to_sign_datasource.dart';

class TextToSignRepositoryImpl implements TextToSignRepository {
  final TextToSignRemoteDataSource remoteDataSource;

  TextToSignRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SignVideo> convertTextToSign(String text) async {
    // 1. نستدعي مصدر البيانات وننتظر النتيجة التي هي من نوع SignVideoModel
    final signVideoModel = await remoteDataSource.convertTextToSign(text);
    // 2. نحول الـ SignVideoModel إلى SignVideo.
    // هذا يفترض أن SignVideoModel لديه خاصية videoUrl وأن SignVideo يمكن إنشاؤه منها.
    // الحل الأفضل هو جعل SignVideoModel يرث من SignVideo.
    return SignVideo(
      inputText: text,
      videoUrl: signVideoModel.videoUrl,
      createdAt: DateTime.now(),
    );
  }
}
