import 'package:eshara/features/Dictionary/domain/entities/sign_entity.dart';

class SignModel extends SignEntity {
  const SignModel({
    required super.id,
    required super.title,
    required super.videoUrl,
    required super.category,
    super.description,
  });

  factory SignModel.fromJson(Map<String, dynamic> json) {
    return SignModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'عنوان غير متوفر',
      videoUrl: json['videoUrl'] ?? '',
      category: json['category'] ?? 'غير مصنف',
      description: json['description'] as String?,
    );
  }
}
