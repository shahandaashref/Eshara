import '../../domain/entities/sign_video.dart';
import '../../domain/repositories/text_to_sign_repository.dart';
import '../datasources/text_to_sign_datasource.dart';

class TextToSignRepositoryImpl implements TextToSignRepository {
  final TextToSignRemoteDataSource remoteDataSource;

  TextToSignRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SignVideo> convertTextToSign(String text) async {
    final signVideoModel = await remoteDataSource.convertTextToSign(text);
    return signVideoModel; // SignVideoModel يرث من SignVideo
  }
}