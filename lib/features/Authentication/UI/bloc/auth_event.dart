// auth_event.dart
abstract class AuthEvent {}

class LoginSubmittedEvent extends AuthEvent {
  final String email;
  final String password;
  LoginSubmittedEvent({required this.email, required this.password});
}

class RegisterSubmittedEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  RegisterSubmittedEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class VerifyOtpEvent extends AuthEvent {
  final String email;
  final String code;
  VerifyOtpEvent({required this.email, required this.code});
}

class ResendOtpEvent extends AuthEvent {
  final String email;
  ResendOtpEvent({required this.email});
}

// ✅ LogoutEvent من غير const
class LogoutEvent extends AuthEvent {
  LogoutEvent();
}
