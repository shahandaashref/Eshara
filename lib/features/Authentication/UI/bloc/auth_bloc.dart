import 'package:eshara/current_user_store.dart';
import 'package:eshara/Core/utils/jwt_helper.dart';
import 'package:eshara/features/Authentication/domain/usecases/login_usecase.dart';
import 'package:eshara/features/Authentication/domain/usecases/register_usecase.dart';
import 'package:eshara/features/Authentication/domain/usecases/resend_otp_usecase.dart';
import 'package:eshara/features/Authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:eshara/features/Authentication/ui/bloc/auth_event.dart';
import 'package:eshara/features/Authentication/ui/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  final CurrentUserStore _userStore = CurrentUserStore.instance;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  }) : super(AuthInitial()) {
    on<LoginSubmittedEvent>(_onLogin);
    on<RegisterSubmittedEvent>(_onRegister);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<LogoutEvent>(_onLogout);
    on<TokenExpiredEvent>(_onTokenExpired);
  }

  Future<void> _onLogin(
    LoginSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userEntity = await loginUseCase(event.email, event.password);

      print('📥 Login Response:');
      print('  📧 Email: ${userEntity.email}');
      print('  👤 Name: ${userEntity.name}');
      print('  🎭 Role: ${userEntity.role}');

      // استخراج الـ role
      String finalRole = userEntity.role;
      if (finalRole == 'User' || finalRole.isEmpty) {
        if (userEntity.token != null) {
          final extractedRole = _extractRoleFromToken(userEntity.token!);
          if (extractedRole != null && extractedRole.isNotEmpty) {
            finalRole = extractedRole;
          }
        }
      }
      if (finalRole == 'User' || finalRole.isEmpty) {
        finalRole = 'user';
      }

      // ✅ حفظ المستخدم مع expiresAt
      _userStore.setUser(
        name: userEntity.name,
        email: userEntity.email,
        role: finalRole,
        token: userEntity.token,
      );

      emit(AuthSuccess(
        user: userEntity,
        message: "تم تسجيل الدخول بنجاح ✅",
      ));
    } catch (e) {
      print('❌ Login Error: $e');
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onRegister(
    RegisterSubmittedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await registerUseCase(event.name, event.email, event.password);
      emit(AuthSuccess(message: "تم إنشاء الحساب بنجاح ✅"));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onVerifyOtp(
    VerifyOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await verifyOtpUseCase(event.email, event.code);
      emit(AuthSuccess(message: "تم التحقق من البريد بنجاح ✅"));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onResendOtp(
    ResendOtpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await resendOtpUseCase(event.email);
      emit(AuthSuccess(message: "تم إعادة إرسال الكود بنجاح 📩"));
    } catch (e) {
      emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    _userStore.clear();
    emit(AuthInitial());
    print('🗑️ User logged out successfully');
  }

  Future<void> _onTokenExpired(
    TokenExpiredEvent event,
    Emitter<AuthState> emit,
  ) async {
    _userStore.clear();
    emit(AuthTokenExpiredState(
      message: "انتهت صلاحية الجلسة، يرجى تسجيل الدخول مرة أخرى",
    ));
    print('⏰ Token expired - auto logout triggered');
  }

  String? _extractRoleFromToken(String token) {
    try {
      final decoded = JwtHelper.decodeToken(token);
      final possibleRoleKeys = [
        'http://schemas.microsoft.com/ws/2008/06/identity/claims/role',
        'role',
        'Role',
        'roles',
      ];

      for (final key in possibleRoleKeys) {
        if (decoded.containsKey(key)) {
          final value = decoded[key];
          if (value is String && value.isNotEmpty) {
            return value;
          } else if (value is List && value.isNotEmpty) {
            return value.first.toString();
          }
        }
      }
      return null;
    } catch (e) {
      print('❌ Error extracting role from token: $e');
      return null;
    }
  }
}

// ✅ Events
class TokenExpiredEvent extends AuthEvent {
  TokenExpiredEvent();
}