import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Dictionary/Domin/entities/sign_entity.dart';
import 'package:flutter/material.dart';


class SignVideoCard extends StatelessWidget {
  final SignEntity sign;
  const SignVideoCard({super.key, required this.sign});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // هنا بنحط الـ Video Preview أو Thumbnail
                Container(color: EsharaTheme.surfaceVariant),
                const Icon(Icons.play_circle_fill, color: EsharaTheme.primaryBlue, size: 40),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(sign.title, style: EsharaTheme.textTheme.titleMedium),
          ),
        ],
      ),
    );
  }
}