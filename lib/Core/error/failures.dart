import 'package:equatable/equatable.dart';

/// [Failure] — كلاس أساسي لكل الأخطاء في التطبيق.
/// استخدامه بيوحد طريقة التعامل مع الأخطاء في طبقة الـ Domain.
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// [ServerFailure] — يمثل خطأ حدث من جهة السيرفر (API).
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// [CacheFailure] — يمثل خطأ حدث أثناء التعامل مع البيانات المحلية (Cache).
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}
