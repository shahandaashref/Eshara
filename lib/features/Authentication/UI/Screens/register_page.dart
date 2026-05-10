import 'package:eshara/Core/Helper/helper.dart';
import 'package:eshara/features/Authentication/UI/Widget/ask_if_sign_in_up.dart';
import 'package:eshara/features/Authentication/UI/Widget/custom_text_form_field.dart';
import 'package:eshara/features/Authentication/UI/Widget/google_media.dart';
import 'package:eshara/features/Authentication/UI/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:eshara/features/Authentication/UI/Widget/or_and_divider.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isChecked=false;
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
                  Text('إنشاء حساب جديد', style: theme.textTheme.displayLarge),

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
                type: 'text',
                label: 'الاسم كامل',
                hintText: "shahanda",
                icon: Icon(Icons.lock_outline),
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
              Row(
                children: [
                  Checkbox(value: _isChecked, onChanged: (bool? newValue) {
        setState(() {
          _isChecked = newValue!;
        });
      },),
                  Text('اوافق على جميع الشروط و الاحكام'),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: Helper.getResponsiveWidth(context, width: 300),
                height: 50,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('إنشاء حساب'),
                ),
              ),
              const SizedBox(height: 10),
              orDividir(),
              GoogleMediaIcons(onPressed: () {}),
              const SizedBox(height: 10),

              AskIfSignInUp(
                ontap: () {
                    Navigator.pushNamed(context, '/login');
                },
                text: 'هل لديك حساب بالفعل؟',
                textTap: ' سجل الدخول',
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
