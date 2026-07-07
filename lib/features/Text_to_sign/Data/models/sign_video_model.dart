import '../../domain/entities/sign_video.dart';

/// [Model] — SignVideoModel
/// بيمثل response من /translate API
class SignVideoModel extends SignVideo {
  SignVideoModel({
    required super.inputText,
    required super.avatarPlayerUrl,
    super.originalText,
    super.simplifiedText,
    super.glossSequence,
    super.unmatchedWords,
    super.timings,
    super.warnings,
    required super.createdAt,
  });

  factory SignVideoModel.fromJson(Map<String, dynamic> json) {
    // Parse gloss_sequence
    final glossList = (json['gloss_sequence'] as List<dynamic>?) ?? [];
    final glosses = glossList.map((g) => GlossItem(
      word: g['word'] ?? '',
      gloss: g['gloss'] ?? '',
      matchScore: (g['match_score'] ?? 0).toDouble(),
      matched: g['matched'] ?? false,
    )).toList();

    // Parse timings
    final timingsJson = json['timings'] as Map<String, dynamic>?;
    final timings = timingsJson != null ? TranslationTimings(
      downloadSeconds: (timingsJson['download_seconds'] ?? 0).toDouble(),
      transcriptionSeconds: (timingsJson['transcription_seconds'] ?? 0).toDouble(),
      geminiSimplificationSeconds: (timingsJson['gemini_simplification_seconds'] ?? 0).toDouble(),
      glossMatchingSeconds: (timingsJson['gloss_matching_seconds'] ?? 0).toDouble(),
      totalSeconds: (timingsJson['total_seconds'] ?? 0).toDouble(),
    ) : null;

    return SignVideoModel(
      inputText: json['original_text'] ?? '',
      avatarPlayerUrl: json['avatar_player_url'] ?? '',
      originalText: json['original_text'] ?? '',
      simplifiedText: json['simplified_text'] ?? '',
      glossSequence: glosses,
      unmatchedWords: List<String>.from(json['unmatched_words'] ?? []),
      timings: timings,
      warnings: List<String>.from(json['warnings'] ?? []),
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'input_text': inputText,
    'avatar_player_url': avatarPlayerUrl,
    'original_text': originalText,
    'simplified_text': simplifiedText,
    'created_at': createdAt.toIso8601String(),
  };
}