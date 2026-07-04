import 'package:dartz/dartz.dart';
import 'package:eshara/Core/error/failures.dart';
import '../entities/translation.dart';
import '../repositories/sign_repository.dart';

class TranslateSignUseCase {
  final SignRepository repository;

  TranslateSignUseCase(this.repository);

  Future<Either<Failure, Translation>> call(String videoPath) {
    return repository.translateSign(videoPath);
  }
}
