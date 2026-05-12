import '../../domain/entities/sign_video.dart';

// ══════════════════════════════════════════════════════
// EVENTS
// ══════════════════════════════════════════════════════
abstract class TextToSignEvent {}

/// بيتبعت لما المستخدم يضغط "تحويل إلى إشارة"
/// [text] — النص المكتوب في الـ TextField
class ConvertTextEvent extends TextToSignEvent {
  final String text;
  ConvertTextEvent({required this.text});
}

/// بيتبعت لما المستخدم يضغط زرار الـ download
class DownloadVideoEvent extends TextToSignEvent {
  final String videoUrl;
  DownloadVideoEvent({required this.videoUrl});
}

/// بيتبعت لما المستخدم يضغط رجوع — بيعمل reset
class ResetTextToSignEvent extends TextToSignEvent {}

// ══════════════════════════════════════════════════════
// STATES
// ══════════════════════════════════════════════════════
abstract class TextToSignState {}

/// الحالة الأولى — text field فاضي جاهز للإدخال
class TextToSignIdleState extends TextToSignState {}

/// بيعالج النص — فيه progress وخطوات
class TextToSignProcessingState extends TextToSignState {
  final double progress;              // 0.0 → 1.0
  final List<TextToSignStep> steps;   // الخطوات الثلاثة

  TextToSignProcessingState({required this.progress, required this.steps});
}

/// الفيديو جاهز للعرض
class TextToSignResultState extends TextToSignState {
  final SignVideo signVideo;
  final bool isPlaying;           // حالة الـ video player

  TextToSignResultState({required this.signVideo, this.isPlaying = false});

  TextToSignResultState copyWith({bool? isPlaying}) => TextToSignResultState(
        signVideo: signVideo,
        isPlaying: isPlaying ?? this.isPlaying,
      );
}

/// حصل خطأ
class TextToSignErrorState extends TextToSignState {
  final String message;
  TextToSignErrorState({required this.message});
}

// ══════════════════════════════════════════════════════
// STEP MODEL
// ══════════════════════════════════════════════════════

/// [TextToSignStep] — نفس نموذج الـ ProcessingStep في sign_to_text
/// بيمثل خطوة واحدة من خطوات التحويل
class TextToSignStep {
  final String label;
  final TextToSignStepStatus status;

  const TextToSignStep({required this.label, required this.status});

  TextToSignStep copyWith({TextToSignStepStatus? status}) =>
      TextToSignStep(label: label, status: status ?? this.status);
}

enum TextToSignStepStatus { pending, inProgress, done }
