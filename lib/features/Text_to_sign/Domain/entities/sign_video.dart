/// [Entity] — GlossItem
/// بيمثل كلمة واحدة في الـ gloss sequence
class GlossItem {
  final String word;
  final String gloss;
  final double matchScore;
  final bool matched;

  GlossItem({
    required this.word,
    required this.gloss,
    required this.matchScore,
    required this.matched,
  });
}

/// [Entity] — TranslationTimings
/// بيمثل أوقات كل خطوة في الترجمة
class TranslationTimings {
  final double downloadSeconds;
  final double transcriptionSeconds;
  final double geminiSimplificationSeconds;
  final double glossMatchingSeconds;
  final double totalSeconds;

  TranslationTimings({
    required this.downloadSeconds,
    required this.transcriptionSeconds,
    required this.geminiSimplificationSeconds,
    required this.glossMatchingSeconds,
    required this.totalSeconds,
  });
}

/// [Entity] — SignVideo
/// بيمثل نتيجة تحويل النص إلى إشارة من الـ API الجديد
class SignVideo {
  final String inputText;
  final String avatarPlayerUrl;
  final String? originalText;
  final String? simplifiedText;
  final List<GlossItem>? glossSequence;
  final List<String>? unmatchedWords;
  final TranslationTimings? timings;
  final List<String>? warnings;
  final DateTime createdAt;

  SignVideo({
    required this.inputText,
    required this.avatarPlayerUrl,
    this.originalText,
    this.simplifiedText,
    this.glossSequence,
    this.unmatchedWords,
    this.timings,
    this.warnings,
    required this.createdAt,
  });
}