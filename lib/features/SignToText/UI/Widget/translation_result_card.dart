import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/SignToText/Domain/entities/translation.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';


class TranslationResultCard extends StatelessWidget {
  final Translation translation;
  final VoidCallback onNewTranslation;

  const TranslationResultCard({
    super.key,
    required this.translation,
    required this.onNewTranslation,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // AI avatar
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E3A5F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const Center(
              child: Icon(Icons.smart_toy_rounded, size: 72, color: Colors.white54),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Result label
        Text(
          AppStrings.translationResults,
          style: tt.headlineMedium!.copyWith(color: EsharaTheme.textPrimary),
          textAlign: TextAlign.right,
        ),

        const SizedBox(height: 10),

        // Result box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: EsharaTheme.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: EsharaTheme.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  translation.translatedText,
                  style: tt.bodyLarge!.copyWith(
                    color: EsharaTheme.textPrimary,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
              const SizedBox(width: 10),
              // Translate icon badge
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: EsharaTheme.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.translate_rounded,
                  size: 18,
                  color: EsharaTheme.primaryBlue,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // New translation button
        ElevatedButton(
          onPressed: onNewTranslation,
          child: Text(AppStrings.newTranslation),
        ),
      ],
    );
  }
}
