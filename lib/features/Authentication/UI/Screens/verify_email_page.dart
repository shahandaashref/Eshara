import 'dart:async';
import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Authentication/UI/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:flutter/material.dart';
import 'package:eshara/Core/Helper/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class VerifyEmailPage extends StatefulWidget {
  final String email;
  const VerifyEmailPage({super.key, required this.email});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  Timer? _timer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  bool _isVerifyingAction = false; // متغير للتفريق بين التحقق وإعادة الإرسال

  @override
  void initState() {
    super.initState();
    _startTimer(); // بدء المؤقت تلقائياً عند فتح الشاشة
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 60;
      _canResend = false;
    });
    _timer?.cancel(); // إلغاء أي مؤقت سابق إن وجد
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // إيقاف المؤقت عند الخروج من الشاشة لمنع استهلاك الذاكرة
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // دالة منفصلة لعملية التحقق لكي نتمكن من استدعائها تلقائياً أو يدوياً
  void _verifyCode(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
    String otpCode = _otpControllers.map((c) => c.text).join();
    if (otpCode.length == 6) {
      _isVerifyingAction = true; // المستخدم يحاول التحقق
      context.read<AuthBloc>().add(VerifyOtpEvent(widget.email, otpCode));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال الرمز المكون من 6 أرقام')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: headerAppBarAndBackgroundAuth(
        context,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // أيقونة الرسالة في التصميم
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 80,
                  color: EsharaTheme.primaryBlue,
                ),

                const SizedBox(height: 20),
                Text(
                  "تحقق من بريدك الإلكتروني",
                  style: Theme.of(context).textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 15),
                Text(
                  "لقد أرسلنا كود إعادة تعيين إلى\n${widget.email}\nالمكون من 6 أرقام للصندوق الوارد في البريد",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: EsharaTheme.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),

                // مربعات الـ OTP
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    6,
                    (index) => _buildOtpBox(context, index),
                  ),
                ),

                const SizedBox(height: 40),

                // زرار التحقق
                SizedBox(
                  width: double.infinity,
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم التحقق بنجاح ✅')),
                        );
                        // توجيه لصفحة اللوجين أو الرئيسية بناءً على الـ Flow
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacementNamed(context, '/login');
                        });
                      } else if (state is AuthActionSuccess) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));

                        // إذا كان الإجراء "تحقق" ونجح، ننقله للصفحة التالية
                        if (_isVerifyingAction) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.pushReplacementNamed(context, '/login');
                          });
                        }
                      } else if (state is AuthFailure) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is AuthLoading;
                      return ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () => _verifyCode(context),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("تحقق من الرمز"),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // إعادة الإرسال
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return TextButton(
                          onPressed: (_canResend && !isLoading)
                              ? () {
                                  _isVerifyingAction =
                                      false; // المستخدم يطلب إعادة الإرسال
                                  context.read<AuthBloc>().add(
                                    ResendOtpEvent(widget.email),
                                  );
                                  _startTimer(); // بدء المؤقت من جديد بعد الضغط
                                }
                              : null, // تعطيل الزر إذا كان المؤقت يعمل
                          child: isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: EsharaTheme.primaryBlue,
                                  ),
                                )
                              : Text(
                                  _canResend
                                      ? "أرسل الكود مرة أخرى"
                                      : "أعد الإرسال بعد $_secondsRemaining ث",
                                  style: TextStyle(
                                    color: _canResend
                                        ? EsharaTheme.primaryBlue
                                        : EsharaTheme.textSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        );
                      },
                    ),
                    const Text("لم يصلك الكود؟"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget صغير لمربع الرقم الواحد
  Widget _buildOtpBox(BuildContext context, int index) {
    return Container(
      width: Helper.getResponsiveWidth(context, width: 45),
      height: Helper.getResponsiveHeight(context, height: 55),
      decoration: BoxDecoration(
        color: EsharaTheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EsharaTheme.border),
      ),
      child: TextFormField(
        controller: _otpControllers[index],
        onChanged: (value) {
          if (value.isNotEmpty) {
            // الانتقال للمربع التالي، أو إخفاء الكيبورد إذا كان المربع الأخير
            if (index < 5) {
              FocusScope.of(context).nextFocus();
            } else {
              FocusScope.of(context).unfocus();
              // التحقق التلقائي بمجرد كتابة الرقم الأخير
              String otpCode = _otpControllers.map((c) => c.text).join();
              if (otpCode.length == 6) {
                _verifyCode(context);
              }
            }
          } else {
            // الرجوع للمربع السابق عند مسح الرقم
            if (index > 0) {
              FocusScope.of(context).previousFocus();
            }
          }
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, // السماح برقم واحد فقط في كل مربع
        style: Theme.of(context).textTheme.headlineLarge,
        decoration: const InputDecoration(
          counterText: '', // إخفاء عداد الحروف (مثل 1/1) من تحت المربع
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
