import 'package:dartz/dartz.dart';
import 'package:eshara/Core/error/failures.dart';
import 'package:eshara/features/SignToText/Domain/entities/translation.dart';
import 'package:eshara/features/SignToText/Domain/repositories/sign_repository.dart';
import '../datasources/sign_remote_datasource.dart';

class SignRepositoryImpl implements SignRepository {
  final SignRemoteDataSource remoteDataSource;

  SignRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Translation>> translateSign(String videoPath) async {
    try {
      // 1. استدعاء الدالة من مصدر البيانات البعيد
      final translationModel = await remoteDataSource.translateSign(videoPath);
      // 2. إرجاع النتيجة بنجاح (بافتراض أن TranslationModel يرث من Translation)
      return Right(translationModel);
    } catch (e) {
      // 3. في حالة حدوث أي خطأ، يتم إرجاع Failure
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
