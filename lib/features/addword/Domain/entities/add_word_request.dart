class AddWordRequest {
  final String arabicMeaning;
  final String notes;
  final String? videoPath;

  AddWordRequest({
    required this.arabicMeaning,
    required this.notes,
    this.videoPath,
  });
}
