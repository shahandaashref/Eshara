import 'package:eshara/Core/Helper/helper.dart';
import 'package:eshara/features/Authentication/UI/Widget/ask_if_sign_in_up.dart';
import 'package:eshara/features/Authentication/UI/Widget/custom_text_form_field.dart';
import 'package:eshara/features/Authentication/UI/Widget/google_media.dart';
import 'package:eshara/features/Authentication/UI/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:eshara/features/Authentication/UI/Widget/or_and_divider.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: headerAppBarAndBackgroundAuth(
        context,

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
                type: 'email',
                label: 'الإيميل *',
                hintText: 'user@example.com',
                icon: Icon(Icons.email_outlined),
              ),
              CustomTextFormField(
                type: 'password',
                label: 'كلمة المرور *',
                hintText: "********",
                icon: Icon(Icons.lock_outline),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {},
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
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('تسجيل الدخول'),
                ),
              ),
              const SizedBox(height: 10),
              orDividir(),
              GoogleMediaIcons(onPressed: () {}),
              const SizedBox(height: 10),

              AskIfSignInUp(
                ontap: () {},
                text: ' سجل الآن',
                textTap: 'ليس لديك حساب ؟',
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
