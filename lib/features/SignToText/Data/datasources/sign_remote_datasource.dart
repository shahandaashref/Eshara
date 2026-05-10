import '../models/translation_model.dart';

abstract class SignRemoteDataSource {
  Future<TranslationModel> translateSign(String videoPath);
}

class SignRemoteDataSourceImpl implements SignRemoteDataSource {
  // TODO: inject http client / dio

  @override
  Future<TranslationModel> translateSign(String videoPath) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 3));

    // TODO: replace with real API call
    return TranslationModel(
      originalSign: 'إشارة يد',
      translatedText: 'أنا اسمي أميرة، وأدرس في جامعة باي سويف، وفي السنة الأخيرة لي',
      createdAt: DateTime.now(),
    );
  }
}
