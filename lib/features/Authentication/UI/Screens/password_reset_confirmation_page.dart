import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Authentication/UI/Widget/header_app_bar_and_backgroun_auth.dart';
import 'package:flutter/material.dart';


class PasswordResetSuccessPage extends StatelessWidget {
  const PasswordResetSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: headerAppBarAndBackgroundAuth(
        context,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 50),
              
              // الأيقونة الصغيرة اللي جنب العنوان في التصميم
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "إعادة تعيين كلمة المرور",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: EsharaTheme.primaryBlue,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  const SizedBox(width: 10),
                  // دي الأيقونة اللي فيها علامة القفل/الصح الصغيرة
                  Image.asset(
                    'assets/icons/reset_success_icon.png', 
                    height: 40,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // النص التوضيحي
              Text(
                "تم إعادة تعيين كلمة المرور الخاصة بك بنجاح\nاضغط على تأكيد لتعيين كلمة مرور جديدة",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: EsharaTheme.textSecondary,
                  height: 1.5,
                  fontFamily: 'Cairo',
                ),
              ),

              const SizedBox(height: 40),

              // زرار "تأكيد"
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      // هنا نوديه لصفحة الـ Reset Password اللي بيدخل فيها الباسورد الجديد
                    },
                    child: const Text(
                      "تأكيد",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              
              const Spacer(),
              
              // الصورة اللي تحت خالص (اليدين اللي بيعملوا إشارة)
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 10),
                  child: Image.asset(
                    'assets/illustrations/gesture_bottom.png', // الصورة اللي في الركن تحت
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}