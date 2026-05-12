/// [Entity] — SignVideo
/// بيمثل نتيجة تحويل النص إلى إشارة.
/// [inputText]  — النص اللي أدخله المستخدم
/// [videoUrl]   — رابط الفيديو المولّد من الـ AI
/// [createdAt]  — وقت إنشاء الترجمة
class SignVideo {
  final String inputText;
  final String videoUrl;
  final DateTime createdAt;

  SignVideo({
    required this.inputText,
    required this.videoUrl,
    required this.createdAt,
  });
}
