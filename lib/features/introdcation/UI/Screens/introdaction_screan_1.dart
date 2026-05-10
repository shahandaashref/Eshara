import 'package:eshara/features/introdcation/UI/widgets/custom_intro_screan.dart';
import 'package:flutter/material.dart';


class IntrodactionScrean1 extends StatelessWidget {
  const IntrodactionScrean1({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIntroScrean(
      onPressed: (){},
      title: 'تواصل بلا قيود',
      isFirstIntroScrean:true,
      content:
          'هذا التطبيق هو جسرك للتفاهم. حوّل صوتك إلى لغة إشارة مرئية فوراً وبكل سهولة.',
      introImageInStack: 'assets/svg/voise.png',
        //SvgPicture.asset('assets/svg/esharavoise.svg') ,
      
    );
  }

}
