import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Authentication/UI/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/Helper/helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  String? email;

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    email ??= ModalRoute.of(context)?.settings.arguments as String?;

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
                  "لقد أرسلنا كود إعادة تعيين إلى\n${email ?? 'بريدك الإلكتروني'}\nالمكون من 6 أرقام للصندوق الوارد في البريد",
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
                        Navigator.pushReplacementNamed(context, '/login');
                      } else if (state is AuthActionSuccess) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(state.message)));
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
                            : () {
                                FocusManager.instance.primaryFocus?.unfocus();
                                String otpCode = _otpControllers
                                    .map((c) => c.text)
                                    .join();
                                if (otpCode.length == 6 && email != null) {
                                  context.read<AuthBloc>().add(
                                    VerifyOtpEvent(email!, otpCode),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'يرجى إدخال الرمز المكون من 6 أرقام',
                                      ),
                                    ),
                                  );
                                }
                              },
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
                    TextButton(
                      onPressed: () {
                        if (email != null) {
                          context.read<AuthBloc>().add(ResendOtpEvent(email!));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('البريد الإلكتروني غير متوفر'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "أرسل الكود مرة أخرى",
                        style: TextStyle(
                          color: EsharaTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
          if (value.length == 1) FocusScope.of(context).nextFocus();
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: Theme.of(context).textTheme.headlineLarge,
        decoration: const InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
