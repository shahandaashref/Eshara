class Translation {
  final String originalSign;
  final String translatedText;
  final DateTime createdAt;
  final double? score;

  Translation({
    required this.originalSign,
    required this.translatedText,
    required this.createdAt,
    this.score,
  });
}
