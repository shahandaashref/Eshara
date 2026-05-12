import 'package:eshara/features/Authentication/UI/Screens/verify_otp_usecase.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_event.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../Domain/usecases/login_usecase.dart';
import '../../Domain/usecases/register_usecase.dart';
import '../../Domain/usecases/resend_otp_usecase.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResendOtpUseCase resendOtpUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyOtpUseCase,
    required this.resendOtpUseCase,
  }) : super(AuthInitial()) {
    // منطق تسجيل الدخول
    on<LoginSubmittedEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await loginUseCase(event.email, event.password);
        // لو نجح، بنبعت حالة النجاح ونمرر بيانات اليوزر معاها
        emit(AuthSuccess("تم تسجيل الدخول بنجاح ✅", user: user));
      } catch (e) {
        // لو حصل مشكلة (مثلاً باسورد غلط)
        emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });

    // منطق تسجيل حساب جديد
    on<RegisterSubmittedEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await registerUseCase(event.name, event.email, event.password);
        emit(AuthSuccess("تم إنشاء الحساب بنجاح ✅"));
      } catch (e) {
        emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });

    // منطق التحقق من الـ OTP
    on<VerifyOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await verifyOtpUseCase(event.email, event.code);
        emit(AuthSuccess("تم التحقق من البريد بنجاح ✅"));
      } catch (e) {
        emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });

    // منطق إعادة إرسال الـ OTP
    on<ResendOtpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await resendOtpUseCase(event.email);
        emit(AuthActionSuccess("تم إعادة إرسال الكود بنجاح 📩"));
      } catch (e) {
        emit(AuthFailure(e.toString().replaceAll('Exception: ', '')));
      }
    });
    // on<ResetPasswordEvent>((event, emit) async { ... });
  }
}
