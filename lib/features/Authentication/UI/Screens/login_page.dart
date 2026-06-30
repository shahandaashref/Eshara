import 'package:eshara/Core/Helper/helper.dart';
import 'package:eshara/features/Authentication/UI/Widget/ask_if_sign_in_up.dart';
import 'package:eshara/features/Authentication/UI/Widget/custom_text_form_field.dart';
import 'package:eshara/features/Authentication/UI/Widget/google_media.dart';
import 'package:eshara/features/Authentication/UI/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:eshara/features/Authentication/UI/Widget/or_and_divider.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_bloc.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_event.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_state.dart';
import 'package:eshara/features/admin/UI/Screens/admin_dashboard_page.dart';
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
                SizedBox(
                  width: Helper.getResponsiveWidth(context, width: 300),
                  height: 50,
                  child: BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        // لو نجح، وديه للصفحة الرئيسية ولا تسمح له بالرجوع لصفحة اللوجين
                        Navigator.pushReplacementNamed(context, '/');
                        // 🔴 هنا هنفرق بين الأدمن واليوزر
                        // تأكدي من فك الكومنت بمجرد تعديل AuthSuccess ليحتوي على user
                        
                        /*
                        if (state.user.role == 'Admin') {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
                          );
                        } else {
                          Navigator.pushReplacementNamed(context, '/');
                        }
                        */
                        
                        // الكود المؤقت لحين ضبط الـ AuthState
                        Navigator.pushReplacementNamed(context, '/'); 
                      } else if (state is AuthFailure) {
                        // لو فشل، طلعي SnackBar بالرسالة اللي جاية من الـ Bloc
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.errorMessage),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: ElevatedButton(
                            onPressed: state is AuthLoading
                                ? null // بنعطل الزرار وهو بيحمل
                                : () {
                                    // بنبعت الـ Event للـ Bloc
                                    context.read<AuthBloc>().add(
                                      LoginSubmittedEvent(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      ),
                                    );
                                  },
                            child: state is AuthLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : const Text("تسجيل دخول"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                orDividir(),
                GoogleMediaIcons(onPressed: () {}),
                const SizedBox(height: 10),

                AskIfSignInUp(
                  ontap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  text: ' سجل الآن',
                  textTap: 'ليس لديك حساب ؟',
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
