import 'package:eshara/Core/Helper/helper.dart';
import 'package:eshara/features/Authentication/UI/Screens/register_page.dart';
import 'package:eshara/current_user_store.dart';
import 'package:eshara/features/Authentication/UI/Widget/ask_if_sign_in_up.dart';
import 'package:eshara/Core/Helper/snackbar_helper.dart';
import 'package:eshara/features/Authentication/UI/Widget/custom_text_form_field.dart';
import 'package:eshara/features/Authentication/UI/Widget/google_media.dart';
import 'package:eshara/features/Authentication/UI/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_bloc.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_event.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_state.dart';
import 'package:eshara/features/Profile/Ui/bloc/profile_bloc.dart';
import 'package:eshara/features/Profile/Ui/bloc/profile_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                    Text('مرحبًا بعودتك', style: theme.textTheme.displayLarge),

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
                  controller: emailController,
                  type: 'email',
                  label: 'الإيميل *',
                  hintText: 'user@example.com',
                  icon: Icon(Icons.email_outlined),
                ),
                CustomTextFormField(
                  controller: passwordController,
                  type: 'password',
                  label: 'كلمة المرور *',
                  hintText: "********",
                  icon: Icon(Icons.lock_outline),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/forget_password');
                    },
                    child: Text(
                      'نسيت كلمة المرور ؟',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess && state.user != null) {
                      // نقوم بتخزين بيانات المستخدم في المخزن المؤقت
                      CurrentUserStore().setUser(
                        name: state.user!.name,
                        email: state.user!.email,
                        role: state.user!.role,
                      );

                      // المنطق الآن بسيط: تحقق من الدور في الكائن الجاهز
                      // تحديث بيانات البروفايل في التطبيق بالكامل
                      context.read<ProfileBloc>().add(LoadProfileEvent());

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) {
                          return; // التحقق من أن الواجهة لا تزال موجودة
                        }

                        // التوجيه إلى AuthWrapper ليقوم هو بتحديد الوجهة الصحيحة
                        Navigator.pushReplacementNamed(context, '/auth');
                      });
                    } else if (state is AuthFailure) {
                      SnackbarHelper.showCustomSnackBar(
                        context,
                        state.errorMessage,
                        isError: true,
                      );
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: Helper.getResponsiveWidth(context, width: 300),
                      height: 50,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null // بنعطل الزرار وهو بيحمل
                            : () {
                                // إرسال event لـ BLoC للتحقق من بيانات الدخول
                                // يتم التحقق أولاً من أن الفورم صالح
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  context.read<AuthBloc>().add(
                                    LoginSubmittedEvent(
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                    ),
                                  );
                                }
                              },
                        child: state is AuthLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text("تسجيل دخول"),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10), // Fixed: was height = 10
                const Divider(),
                GoogleMediaIcons(
                  onPressed: () {},
                ), // Fixed: was onPressed = () {}
                const SizedBox(height: 10), // Fixed: was height = 10

                AskIfSignInUp(
                  ontap: () {
                    // نستخدم pushReplacement لتجنب تراكم الصفحات
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    ); // Fixed: was /login
                  },
                  text:
                      'ليس لديك حساب ؟', // Fixed: Swapped text and textTap values and syntax
                  textTap:
                      ' سجل الآن', // Fixed: Swapped text and textTap values and syntax
                ),
                const SizedBox(height: 10), // Fixed: was height = 10
              ],
            ),
          ),
        ),
      ),
    );
  }
}
