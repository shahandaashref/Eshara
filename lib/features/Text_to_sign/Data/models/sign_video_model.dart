import '../../domain/entities/sign_video.dart';

/// [Model] — SignVideoModel
/// بيورث من [SignVideo] ويضيف fromJson/toJson
class SignVideoModel extends SignVideo {
  SignVideoModel({
    required super.inputText,
    required super.videoUrl,
    required super.createdAt,
  });

  factory SignVideoModel.fromJson(Map<String, dynamic> json) {
    return SignVideoModel(
      inputText: json['input_text'] as String,
      videoUrl: json['video_url'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'input_text': inputText,
    'video_url': videoUrl,
    'created_at': createdAt.toIso8601String(),
  };
}
