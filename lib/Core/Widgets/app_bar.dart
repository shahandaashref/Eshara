import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';

class BuildAppBar extends StatelessWidget {
  final TextTheme tt;
  const BuildAppBar({super.key, required this.tt});

  @override
  Widget build(BuildContext context) {
    return   Container(
    color: EsharaTheme.surface,
    // إضافة مسافة علوية (padding) ديناميكية لتجنب التداخل مع شريط حالة الهاتف (Status Bar)
    padding: EdgeInsets.only(
      top: MediaQuery.of(context).padding.top + 8,
      bottom: 12,
      right: 20,
      left: 20,
    ),
    child: Row(
      children: [
        // مجموعة الأيقونات الموجودة على يسار الشاشة
        Row(
          children: [
            _AppBarIcon(icon: Icons.person_outline_rounded, onTap: () {
              Navigator.pushNamed(context, '/profile');
            }),
            const SizedBox(width: 8),
            _AppBarIcon(
              icon: Icons.notifications_outlined,
              onTap: () {
                Navigator.pushNamed(context, '/notifications');
              },
              hasBadge: true, // إظهار نقطة حمراء كدليل على وجود إشعار جديد
            ),
          ],
        ),
        const Spacer(),
        // اسم التطبيق واللوجو على يمين الشاشة

        const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                //gradient: EsharaTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset('assets/logo/logo.png',width: 70,)
            ),
        // Row(
        //   children: [
        //     Text(
        //       AppStrings.appName,
        //       style: tt.headlineLarge!.copyWith(color: EsharaTheme.primaryBlue),
        //     ),
            
        //   ],
        // ),
      ],
    ),
  );
  }
}



/// ويدجت (Widget) مخصص ومصغر لإنشاء أيقونات الـ AppBar بشكل متناسق ومربع
/// يدعم إضافة نقطة التنبيهات (Badge) للفت انتباه المستخدم
class _AppBarIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;

  const _AppBarIcon({
    required this.icon,
    required this.onTap,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // الخلفية المربعة للأيقونة
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: EsharaTheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: EsharaTheme.textSecondary),
          ),
          // إظهار النقطة الحمراء للإشعارات إذا تم تمرير hasBadge = true
          if (hasBadge)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: EsharaTheme.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
