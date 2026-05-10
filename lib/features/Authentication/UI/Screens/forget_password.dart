import 'package:eshara/features/Authentication/UI/Widget/custom_text_form_field.dart';
import 'package:eshara/features/Authentication/UI/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:flutter/material.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: headerAppBarAndBackgroundAuth(
        context,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text('نسيت كلمة المرور', style: Theme.of(context).textTheme.displayLarge),

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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: Text('إعادة تعيين كلمة المرور'),
                ),
                
                ]
                
                ),
                )
                )
        );
  }
}