import 'package:eshara/Core/Helper/helper.dart';
import 'package:eshara/features/Authentication/ui/Widget/ask_if_sign_in_up.dart';
import 'package:eshara/features/Authentication/ui/Widget/custom_text_form_field.dart';
import 'package:eshara/Core/Helper/snackbar_helper.dart';
import 'package:eshara/features/Authentication/ui/Widget/google_media.dart';
import 'package:eshara/features/Authentication/ui/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:eshara/features/Authentication/ui/Widget/or_and_divider.dart';
import 'package:eshara/features/Authentication/ui/bloc/auth_bloc.dart';
import 'package:eshara/features/Authentication/ui/bloc/auth_event.dart';
import 'package:eshara/features/Authentication/ui/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_isChecked) {
        SnackbarHelper.showCustomSnackBar(
          context,
          'يجب الموافقة على الشروط والأحكام',
          isError: true,
        );
        return;
      }
      context.read<AuthBloc>().add(
        RegisterSubmittedEvent(
          name: _nameController.text.trim(),

          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: headerAppBarAndBackgroundAuth(
        context,

        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'إنشاء حساب جديد',
                      style: theme.textTheme.displayLarge,
                    ),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        'assets/svg/voise.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                  ],
                ),
                CustomTextFormField(
                  controller: _nameController,
                  type: 'text',
                  label: 'الاسم كامل',
                  hintText: "shahanda",
                  icon: Icon(Icons.lock_outline),
                ),
                CustomTextFormField(
                  controller: _emailController,
                  type: 'email',
                  label: 'الإيميل *',
                  hintText: 'user@example.com',
                  icon: Icon(Icons.email_outlined),
                ),

                CustomTextFormField(
                  controller: _passwordController,
                  type: 'password',
                  label: 'كلمة المرور *',
                  hintText: "********",
                  icon: Icon(Icons.lock_outline),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          _isChecked = newValue!;
                        });
                      },
                    ),
                    Text('اوافق على جميع الشروط و الاحكام'),
                  ],
                ),
                const SizedBox(height: 10),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      SnackbarHelper.showCustomSnackBar(
                        context,
                        'تم إنشاء الحساب بنجاح ✅',
                        isError: false,
                      ); // هنا تم استخدام SnackbarHelper

                      // توجيه المستخدم لصفحة التحقق مع إرسال الإيميل
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        Navigator.pushReplacementNamed(
                          context,
                          '/verify_email',
                          arguments: _emailController.text.trim(),
                        );
                      });
                    } else if (state is AuthFailure) {
                      SnackbarHelper.showCustomSnackBar(
                        context,
                        state.errorMessage,
                        isError: true,
                      ); // هنا تم استخدام SnackbarHelper

                      // التحقق إذا كان الخطأ يعني أن الإيميل موجود بالفعل
                      // (يجب أن يكون الـ API يرجع رسالة خطأ واضحة مثل هذه)
                      if (state.errorMessage.contains(
                            'البريد الإلكتروني موجود بالفعل',
                          ) ||
                          state.errorMessage.contains(
                            'The email has already been taken',
                          ) ||
                          state.errorMessage.contains('Email already exists')) {
                        // توجيه المستخدم لصفحة التحقق من الإيميل بدلاً من التسجيل مرة أخرى
                        if (_emailController.text.trim().isNotEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!mounted) return;
                            Navigator.pushReplacementNamed(
                              context,
                              '/verify_email',
                              arguments: _emailController.text.trim(),
                            );
                          });
                        }
                      }
                    }
                  },
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: Helper.getResponsiveWidth(context, width: 300),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _register,
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('إنشاء حساب'),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                orDividir(),
                GoogleMediaIcons(onPressed: () {}),
                const SizedBox(height: 10),

                AskIfSignInUp(
                  ontap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  text: 'هل لديك حساب بالفعل؟',
                  textTap: ' سجل الدخول',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
