import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';


/// [Widget] — ProfileInfoRow
/// بيعرض row واحدة من بيانات المستخدم (اسم، ايميل)
/// [icon] — الأيقونة على اليسار
/// [label] — اسم الـ field
/// [value] — القيمة
class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: EsharaTheme.textHint),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(value,
                    style: tt.bodyLarge!.copyWith(color: EsharaTheme.textPrimary)),
                Text(label, style: tt.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
