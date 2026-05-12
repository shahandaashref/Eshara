abstract class AuthEvent {}

// حدث تسجيل الدخول
class LoginSubmittedEvent extends AuthEvent {
  final String email;
  final String password;
  LoginSubmittedEvent(this.email, this.password);
}

// حدث إنشاء حساب جديد
class RegisterSubmittedEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterSubmittedEvent(this.name, this.email, this.password);
}

// حدث التحقق من الـ OTP
class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String code;
  VerifyOtpEvent(this.email, this.code);
}

// حدث إعادة إرسال الـ OTP
class ResendOtpEvent extends AuthEvent {
  final String email;
  ResendOtpEvent(this.email);
}
