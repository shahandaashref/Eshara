import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Dictionary/Domain/entities/sign_entity.dart';
import 'package:flutter/material.dart';

class SignVideoCard extends StatelessWidget {
  final SignEntity sign;
  final VoidCallback onTap;
   const SignVideoCard({super.key, required this.sign, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior:
          Clip.antiAlias, // لضمان أن تأثير الضغط لا يتجاوز حدود البطاقة
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // هنا بنحط الـ Video Preview أو Thumbnail
                  Container(color: EsharaTheme.surfaceVariant),
                  const Icon(
                    Icons.play_circle_fill,
                    color: EsharaTheme.primaryBlue,
                    size: 40,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(sign.title, style: EsharaTheme.textTheme.titleMedium),
            ),
          ],
        ),
      ),
    );
  }
}
