import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Authentication/ui/Widget/custom_text_form_field.dart';
import 'package:eshara/features/Authentication/ui/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:flutter/material.dart';


class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: headerAppBarAndBackgroundAuth(
        context,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  "إعادة تعيين كلمة المرور",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                const SizedBox(height: 15),
                const Text(
                  "قم بتعيين كلمة مرور جديدة تأكد من أنها تختلف\nعن السابقة لضمان الأمان",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: EsharaTheme.textSecondary),
                ),
                const SizedBox(height: 30),

                // استخدام الـ Widget بتاعك للباسورد الجديد
                CustomTextFormField(
                  type: 'password',
                  label: 'كلمة المرور الجديدة',
                  hintText: '********',
                  icon: const Icon(Icons.lock_outline),
                ),

                // تأكيد الباسورد
                CustomTextFormField(
                  type: 'password',
                  label: 'تأكيد كلمة المرور',
                  hintText: '********',
                  icon: const Icon(Icons.lock_reset),
                ),

                const SizedBox(height: 40),

                // زرار التحديث
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ElevatedButton(
                      onPressed: () {
                        // هنا نفتح شاشة النجاح
                      },
                      child: const Text("تحديث كلمة المرور"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}