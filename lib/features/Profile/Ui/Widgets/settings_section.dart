import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';


/// [Widget] — SettingsSection
/// بيعرض قسم "إعدادات الحساب" اللي فيه روابط تعديل الملف وتسجيل الخروج
class SettingsSection extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onLogout;

  const SettingsSection({
    super.key,
    required this.onEditProfile,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: EsharaTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: EsharaTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('إعدادات الحساب',
              style: tt.titleLarge!.copyWith(color: EsharaTheme.primaryBlue)),
          const SizedBox(height: 12),

          // ── تعديل الملف الشخصي ────────────────────────────────────────
          _SettingsRow(
            icon: Icons.edit_outlined,
            label: 'تعديل الملف الشخصي',
            iconColor: EsharaTheme.primaryBlue,
            onTap: onEditProfile,
            tt: tt,
          ),

          const Divider(height: 1, color: EsharaTheme.divider),

          // ── تسجيل الخروج ──────────────────────────────────────────────
          _SettingsRow(
            icon: Icons.logout_rounded,
            label: 'تسجيل الخروج',
            iconColor: EsharaTheme.error,
            labelColor: EsharaTheme.error,
            onTap: onLogout,
            tt: tt,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color? labelColor;
  final VoidCallback onTap;
  final TextTheme tt;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTap,
    required this.tt,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // سهم للـ navigation
            Icon(Icons.chevron_left_rounded,
                color: EsharaTheme.textHint, size: 20),
            const Spacer(),
            Text(label,
                style: tt.bodyLarge!.copyWith(
                    color: labelColor ?? EsharaTheme.textPrimary)),
            const SizedBox(width: 10),
            Icon(icon, color: iconColor, size: 20),
          ],
        ),
      ),
    );
  }
}
