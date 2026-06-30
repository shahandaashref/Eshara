import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/Widgets/app_bottom_nav.dart';
import 'package:eshara/features/Dictionary/Ui/Screens/dictionary_page.dart';
import 'package:eshara/features/Home/UI/Screens/home_page.dart';
import 'package:eshara/features/Profile/Ui/Screens/profile_page.dart';
import 'package:eshara/features/SignToText/UI/Screens/sign_to_text_page.dart';
import 'package:eshara/features/Text_to_sign/Ui/Screens/text_to_sign_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  // قائمة الشاشات المرتبطة بعناصر شريط التنقل السفلي بالترتيب
  final List<Widget> _pages = const [
    HomePage(),
    DictionaryPage(),
    SignToTextPage(),
    TextToSignPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        // نستخدم IndexedStack للحفاظ على حالة الصفحات في الخلفية وعدم إعادة بنائها
        body: IndexedStack(index: _currentIndex, children: _pages),
        bottomNavigationBar: AppBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
      ),
    );
  }
}
