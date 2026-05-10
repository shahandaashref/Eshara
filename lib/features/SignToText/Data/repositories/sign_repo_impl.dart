import '../../Domain/entities/translation.dart';
import '../../Domain/repositories/sign_repository.dart';
import '../datasources/sign_remote_datasource.dart';
import '../models/translation_model.dart';

/// [Repository Implementation] — SignRepositoryImpl
/// هذه هي الطبقة التي تتصل بالـ DataSource لجلب البيانات.
/// هي الـ implementation الفعلية للعقد (Contract) الموجود في الـ Domain Layer.
class SignRepositoryImpl implements SignRepository {
  final SignRemoteDataSource remoteDataSource;

  SignRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Translation> translateSign(String videoPath) async {
    try {
      // The remote data source returns a TranslationModel.
      // We assume TranslationModel is a subtype of Translation, so we can return it directly.
      final TranslationModel translationModel = await remoteDataSource
          .translateSign(videoPath);
      return translationModel;
    } catch (e) {
      // Handle exceptions from the data source (e.g., network errors)
      rethrow;
    }
  }
}
