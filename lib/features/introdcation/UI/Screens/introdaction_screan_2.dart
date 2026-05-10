import 'package:eshara/features/introdcation/UI/widgets/custom_intro_screan.dart';
import 'package:flutter/material.dart';

class IntrodactionScrean2 extends StatelessWidget {
  const IntrodactionScrean2({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIntroScrean(
      onPressed: (){},

      title: 'خطوتان بسيطتان',
      content:
          ' اضغط على زر التسجيل وتحدث بوضوح. ستظهر ترجمة الجمل الشائعة في فيديو لغة الإشارة فوراً.',
      introImageInStack: 'assets/logo/imgintro2.png',
    );
  }
}
//===================================================//
//==================================================//

