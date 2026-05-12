import 'package:equatable/equatable.dart';

class SignEntity extends Equatable {
  final String id;
  final String title;
  final String videoUrl; // غيرناها لفيديو
  final String category;
  final String? description;

  const SignEntity({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.category,
    this.description,
  });

  @override
  List<Object?> get props => [id, title, videoUrl, category, description];
}
