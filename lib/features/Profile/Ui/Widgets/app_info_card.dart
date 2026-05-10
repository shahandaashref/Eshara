import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';

/// [Widget] — AppInfoCard
/// بيعرض معلومات التطبيق (الإصدار، المطور، تاريخ التحديث)
class AppInfoCard extends StatelessWidget {
  const AppInfoCard({super.key});

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
          Text('معلومات التطبيق',
              style: tt.titleLarge!.copyWith(color: EsharaTheme.primaryBlue)),
          const SizedBox(height: 12),
          _InfoRow(label: 'الإصدار', value: '1.0.0', tt: tt),
          const Divider(height: 1, color: EsharaTheme.divider),
          _InfoRow(label: 'المطور', value: 'Eshara AI v1.0', tt: tt),
          const Divider(height: 1, color: EsharaTheme.divider),
          _InfoRow(label: 'تاريخ التحديث', value: '2026', tt: tt),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final TextTheme tt;

  const _InfoRow({
    required this.label,
    required this.value,
    required this.tt,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: tt.bodyMedium!.copyWith(color: EsharaTheme.textPrimary)),
          Text(label, style: tt.bodyMedium),
        ],
      ),
    );
  }
}
