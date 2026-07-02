import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';

/// [Widget] — AdminAppBar
/// AppBar مشتركة بين كل صفحات الأدمن
class AdminAppBar extends StatelessWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBack;

  const AdminAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showBack = true,
  });

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
        children: [
          if (actions != null) ...actions! else const SizedBox(width: 36),
          const Spacer(),
          Text(title, style: tt.headlineLarge),
          const Spacer(),
          if (showBack)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: EsharaTheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: EsharaTheme.textPrimary,
                ),
              ),
            )
          else
            const SizedBox(width: 36),
        ],
      ),
    );
  }
}

/// [Widget] — AdminStatCard
/// بيعرض إحصائية واحدة في الداشبورد
class AdminStatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const AdminStatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EsharaTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EsharaTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: tt.displayMedium!.copyWith(
                  color: EsharaTheme.primaryBlue,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(label, style: tt.bodySmall),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
        ],
      ),
    );
  }
}

/// [Widget] — AdminWordTile
/// بيعرض كلمة واحدة في القائمة مع أزرار تعديل وحذف
class AdminWordTile extends StatelessWidget {
  final String word;
  final String? thumbnailUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AdminWordTile({
    super.key,
    required this.word,
    this.thumbnailUrl,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: EsharaTheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: EsharaTheme.border),
      ),
      child: Row(
        children: [
          // أزرار التعديل والحذف
          Row(
            children: [
              _ActionBtn(
                icon: Icons.edit_rounded,
                color: EsharaTheme.primaryBlue,
                onTap: onEdit,
              ),
              const SizedBox(width: 8),
              _ActionBtn(
                icon: Icons.delete_rounded,
                color: EsharaTheme.error,
                onTap: onDelete,
              ),
            ],
          ),
          const Spacer(),
          // اسم الكلمة
          Text(
            word,
            style: tt.titleMedium!.copyWith(color: EsharaTheme.textPrimary),
          ),
          const SizedBox(width: 12),
          // صورة مصغرة
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 48,
              height: 48,
              color: EsharaTheme.surfaceVariant,
              child: const Icon(
                Icons.play_circle_outline_rounded,
                color: EsharaTheme.primaryBlue,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color, size: 16),
      ),
    );
  }
}

/// [Widget] — ConfirmDeleteSheet
/// Bottom sheet مشترك لتأكيد الحذف
class ConfirmDeleteSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onConfirm;

  const ConfirmDeleteSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: EsharaTheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_rounded,
                color: EsharaTheme.error,
                size: 28,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: tt.headlineMedium!.copyWith(
                color: EsharaTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(subtitle, style: tt.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  onConfirm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: EsharaTheme.error,
                  side: const BorderSide(color: EsharaTheme.error),
                ),
                child: Text(title),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('إلغاء'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
