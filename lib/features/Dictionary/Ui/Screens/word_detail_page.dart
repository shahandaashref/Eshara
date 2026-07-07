import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Dictionary/domain/entities/sign_entity.dart';
import 'package:flutter/material.dart';

/// [Page] — WordDetailPage
/// تعرض تفاصيل الكلمة (فيديو، عنوان، وصف) للمستخدم.
class WordDetailPage extends StatelessWidget {
  final SignEntity sign;

  const WordDetailPage({super.key, required this.sign});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: EsharaTheme.background,
        appBar: AppBar(
          title: Text(sign.title),
          backgroundColor: EsharaTheme.background,
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Player/Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 220,
                  color: EsharaTheme.surfaceVariant, // Placeholder for video
                  child: const Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_fill,
                        color: EsharaTheme.primaryBlue,
                        size: 60,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Word Title
              Text(sign.title, style: tt.displaySmall),
              const SizedBox(height: 16),

              // Description
              Text('شرح الحركة', style: tt.titleMedium),
              const SizedBox(height: 8),
              Text(
                sign.description ?? 'لا يوجد وصف لهذه الكلمة حالياً.',
                style: tt.bodyLarge?.copyWith(height: 1.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
