import '../../Domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

// حالة النجاح (بناخد معانا بيانات اليوزر)
class AuthSuccess extends AuthState {
  final String? message;
  final UserEntity? user;
  AuthSuccess({this.message, this.user});
}

// حالة لرسائل النجاح التي لا تحتاج لانتقال لصفحة أخرى (مثل إعادة إرسال الكود)
class AuthActionSuccess extends AuthState {
  final String message;
  AuthActionSuccess(this.message);
}

// حالة الفشل (بناخد معانا رسالة الخطأ)
class AuthFailure extends AuthState {
  final String errorMessage;
  AuthFailure(this.errorMessage);
}
