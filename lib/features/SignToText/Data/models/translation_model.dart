import '../../Domain/entities/translation.dart';

class TranslationModel extends Translation {
  TranslationModel({
    required super.originalSign,
    required super.translatedText,
    required super.createdAt,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      originalSign: json['original_sign'] as String,
      translatedText: json['translated_text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'original_sign': originalSign,
    'translated_text': translatedText,
    'created_at': createdAt.toIso8601String(),
  };
}
