import 'package:eshara/features/Authentication/UI/Screens/login_page.dart';
import 'package:eshara/features/introdcation/UI/widgets/custom_intro_screan.dart';
import 'package:flutter/material.dart';

class IntrodactionScrean3 extends StatelessWidget {
  const IntrodactionScrean3({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIntroScrean(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      },

      title: 'حان وقت البدء!',
      isFirstIntroScrean: true,
      content:
          'أنشئ حسابك الآن أو سجّل الدخول وابدأ في استخدام ميزة الترجمة المباشرة.',
      introImageInStack: 'assets/logo/Rectangle 1219 (3).png',

      //SvgPicture.asset('assets/svg/esharavoise.svg') ,
    );
  }
}
