import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';

/// [Widget] - CustomAppBar
/// ويدجت موحد ومرن لإنشاء شريط التطبيق العلوي (AppBar) في جميع أنحاء التطبيق.
/// يقبل متغيرات لتخصيص العنوان، الأزرار، وإظهار زر الرجوع.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? leadingActions; // أزرار على اليسار (في LTR)
  final List<Widget>? trailingActions; // أزرار على اليمين (في LTR)
  final bool showBackButton;
  final Widget? titleWidget;

  const CustomAppBar({
    super.key,
    this.title,
    this.leadingActions,
    this.trailingActions,
    this.showBackButton = false,
    this.titleWidget,
  }) : assert(
         title == null || titleWidget == null,
         'Cannot provide both a title and a titleWidget',
       );

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      color: EsharaTheme.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        right: 20,
        left: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // الأزرار اليمنى (Trailing in LTR, Leading in RTL)
          if (trailingActions != null)
            Row(mainAxisSize: MainAxisSize.min, children: trailingActions!)
          else if (showBackButton)
            const _AppBarBackButton()
          else
            const SizedBox(width: 40), // للحفاظ على التوسيط
          // العنوان
          if (title != null)
            Text(title!, style: tt.headlineLarge)
          else if (titleWidget != null)
            titleWidget!,

          // الأزرار اليسرى (Leading in LTR, Trailing in RTL)
          if (leadingActions != null)
            Row(mainAxisSize: MainAxisSize.min, children: leadingActions!)
          else
            const SizedBox(width: 40), // للحفاظ على التوسيط
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}

class _AppBarBackButton extends StatelessWidget {
  const _AppBarBackButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios_new_rounded),
      color: EsharaTheme.textPrimary,
    );
  }
}
