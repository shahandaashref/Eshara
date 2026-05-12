import '../../domain/entities/sign_video.dart';
import '../../domain/repositories/text_to_sign_repository.dart';
import '../datasources/text_to_sign_datasource.dart';

/// [Repository Implementation] — TextToSignRepositoryImpl
/// الوسيط بين الـ domain layer والـ datasource
class TextToSignRepositoryImpl implements TextToSignRepository {
  final TextToSignRemoteDataSource remoteDataSource;

  TextToSignRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SignVideo> convertTextToSign(String text) async {
    return await remoteDataSource.convertTextToSign(text);
  }
}
