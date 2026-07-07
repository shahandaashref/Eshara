import 'package:dartz/dartz.dart';
import 'package:eshara/Core/error/failures.dart';
import 'package:eshara/features/SignToText/domain/entities/translation.dart';

abstract class SignRepository {
  /// يترجم فيديو الإشارة إلى نص. يُرجع إما [Failure] أو [Translation].
  Future<Either<Failure, Translation>> translateSign(String videoPath);
}