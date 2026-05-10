import 'package:eshara/features/SignToText/Domain/entities/translation.dart';



abstract class SignState {}

/// الحالة الأولى — كاميرا جاهزة، مفيش تسجيل
class SignIdleState extends SignState {}

/// بيسجل دلوقتي
class SignRecordingState extends SignState {}

/// بيعالج الإشارة — فيه progress و steps
class SignProcessingState extends SignState {
  final double progress; // 0.0 → 1.0
  final List<ProcessingStep> steps;

  SignProcessingState({required this.progress, required this.steps});
}

/// النتيجة جاهزة
class SignResultState extends SignState {
  final Translation translation;

  SignResultState({required this.translation});
}

/// حصل خطأ
class SignErrorState extends SignState {
  final String message;

  SignErrorState({required this.message});
}

// ── Processing steps model ────────────────────────────────────────────────
class ProcessingStep {
  final String label;
  final StepStatus status;

  const ProcessingStep({required this.label, required this.status});

  ProcessingStep copyWith({StepStatus? status}) =>
      ProcessingStep(label: label, status: status ?? this.status);
}

enum StepStatus { pending, inProgress, done }
