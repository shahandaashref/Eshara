
import 'package:eshara/features/SignToText/domain/entities/translation.dart';

class TranslationModel extends Translation {
  TranslationModel({
    required super.originalSign,
    required super.translatedText,
    required super.createdAt,
    super.score,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      // لو السيرفر مابيرجعش original_sign هنحط قيمة افتراضية
      originalSign: json['original_sign'] as String? ?? 'فيديو إشارة',
      translatedText: json['label'] as String? ?? 'غير معروف',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      score: (json['score'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'original_sign': originalSign,
    'label': translatedText,
    'created_at': createdAt.toIso8601String(),
    'score': score,
  };
}
