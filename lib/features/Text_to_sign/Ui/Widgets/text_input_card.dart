import 'package:eshara/Core/Helper/theme.dart';
import 'package:flutter/material.dart';

/// [Widget] — TextInputCard
/// الـ card اللي فيها الـ TextField اللي المستخدم يكتب فيها النص
/// [controller]    — الـ TextEditingController
/// [onChanged]     — callback لما النص يتغير (لتحديث الـ char count)
/// [maxLength]     — الحد الأقصى للحروف (200)
class TextInputCard extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final int maxLength;

  const TextInputCard({
    super.key,
    required this.controller,
    required this.onChanged,
    this.maxLength = 200,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: EsharaTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: EsharaTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── TextField ─────────────────────────────────────────────────
          TextField(
            controller: controller,
            onChanged: onChanged,
            maxLines: 4,
            maxLength: maxLength,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            buildCounter: (_, {required currentLength, required isFocused, maxLength}) => null,
            style: tt.bodyLarge!.copyWith(color: EsharaTheme.textPrimary),
            decoration: InputDecoration(
              hintText: 'اكتب النص هنا...',
              hintStyle: tt.bodyLarge!.copyWith(color: EsharaTheme.textHint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
              filled: false,
            ),
          ),

          // ── Footer: copy icon + char count ───────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // عداد الحروف
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: controller,
                  builder: (_, value, __) => Text(
                    '${value.text.length} / $maxLength',
                    style: tt.bodySmall,
                  ),
                ),
                const Spacer(),
                // زرار النسخ
                GestureDetector(
                  onTap: () {
                    // TODO: copy to clipboard
                  },
                  child: const Icon(
                    Icons.copy_rounded,
                    size: 18,
                    color: EsharaTheme.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
