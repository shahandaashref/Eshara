import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:eshara/Core/Helper/theme.dart';
import '../constants/app_strings.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      // الإعدادات الأساسية عشان تطلع زي الصورة
      index: currentIndex,
      height: 75,
      items: [
        CurvedNavigationBarItem(
          child: _buildIcon(Icons.home_rounded, 0),
          label: AppStrings.navHome,
          labelStyle: _labelStyle(0),
        ),
        CurvedNavigationBarItem(
          child: _buildIcon(Icons.menu_book_rounded, 1),
          label: AppStrings.navLibrary,
          labelStyle: _labelStyle(1),
        ),
        CurvedNavigationBarItem(
          child: _buildIcon(Icons.videocam_rounded, 2),
          label: "ترجمة الإشارة",
          labelStyle: _labelStyle(2),
        ),
        CurvedNavigationBarItem(
          child: _buildIcon(Icons.text_fields_rounded, 3),
          label: "ترجمة النص",
          labelStyle: _labelStyle(3),
        ),
        CurvedNavigationBarItem(
          child: _buildIcon(Icons.person_rounded, 4),
          label: AppStrings.navProfile,
          labelStyle: _labelStyle(4),
        ),
      ],
      color: EsharaTheme.primaryBlue, // لون الشريط نفسه
      buttonBackgroundColor: EsharaTheme.primaryBlue, // لون الدائرة اللي بتطلع فوق
      backgroundColor: Colors.transparent, // لون خلفية الصفحة اللي ورا الشريط
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      onTap: onTap,
    );
  }

  // Helper لجعل الأيقونة بيضاء دايماً زي التصميم
  Widget _buildIcon(IconData icon, int index) {
    return Icon(
      icon,
      size: 26,
      color: Colors.white,
    );
  }

  // ستايل الخط العربي (Cairo) من الثيم بتاعك
  TextStyle _labelStyle(int index) {
    return TextStyle(
      fontFamily: 'Cairo',
      fontSize: 12,
      fontWeight: currentIndex == index ? FontWeight.bold : FontWeight.normal,
      color: Colors.white,
    );
  }
}