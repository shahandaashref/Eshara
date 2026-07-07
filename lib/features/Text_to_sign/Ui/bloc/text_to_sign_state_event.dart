import 'package:eshara/features/Text_to_sign/domain/entities/sign_video.dart';

// ── Events ─────────────────────────────────────────────────────────────────

abstract class TextToSignEvent {}

class ConvertTextEvent extends TextToSignEvent {
  final String text;
  ConvertTextEvent({required this.text});
}

class ResetTextToSignEvent extends TextToSignEvent {}

class DownloadVideoEvent extends TextToSignEvent {
  final String videoUrl;
  DownloadVideoEvent({required this.videoUrl});
}

// ── States ─────────────────────────────────────────────────────────────────

abstract class TextToSignState {}

class TextToSignIdleState extends TextToSignState {}

class TextToSignProcessingState extends TextToSignState {
  final double progress;
  final List<TextToSignStep> steps;
  final String? currentStage; // simplifying | matching | done

  TextToSignProcessingState({
    required this.progress,
    required this.steps,
    this.currentStage,
  });
}

class TextToSignResultState extends TextToSignState {
  final SignVideo signVideo;
  TextToSignResultState({required this.signVideo});
}

class TextToSignErrorState extends TextToSignState {
  final String message;
  TextToSignErrorState({required this.message});
}

// ── Step Model ─────────────────────────────────────────────────────────────

enum TextToSignStepStatus { pending, inProgress, done }

class TextToSignStep {
  final String label;
  final TextToSignStepStatus status;

  const TextToSignStep({
    required this.label,
    required this.status,
  });

  TextToSignStep copyWith({TextToSignStepStatus? status}) {
    return TextToSignStep(
      label: label,
      status: status ?? this.status,
    );
  }
}