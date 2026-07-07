import 'package:eshara/features/Text_to_sign/domain/entities/sign_video.dart';
import 'package:eshara/features/Text_to_sign/domain/usecases/convert_text_to_sign.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'text_to_sign_state_event.dart';

/// [BLoC] — TextToSignBloc
class TextToSignBloc extends Bloc<TextToSignEvent, TextToSignState> {
  final ConvertTextToSignUseCase convertTextToSignUseCase;

  TextToSignBloc({required this.convertTextToSignUseCase})
      : super(TextToSignIdleState()) {
    on<ConvertTextEvent>(_onConvert);
    on<ResetTextToSignEvent>(_onReset);
    on<DownloadVideoEvent>(_onDownload);
  }

  Future<void> _onConvert(
    ConvertTextEvent event,
    Emitter<TextToSignState> emit,
  ) async {
    final steps = [
      const TextToSignStep(
        label: 'تبسيط النص باستخدام Gemini',
        status: TextToSignStepStatus.pending,
      ),
      const TextToSignStep(
        label: 'مطابقة الكلمات مع قاعدة البيانات',
        status: TextToSignStepStatus.pending,
      ),
      const TextToSignStep(
        label: 'إنشاء رابط الأفاتار ثلاثي الأبعاد',
        status: TextToSignStepStatus.pending,
      ),
    ];

    try {
      // ── Step 1: Simplifying ─────────────────────────────────────────
      emit(TextToSignProcessingState(
        progress: 0.2,
        steps: _update(steps, 0, TextToSignStepStatus.inProgress),
        currentStage: 'simplifying',
      ));
      await Future.delayed(const Duration(milliseconds: 800));

      emit(TextToSignProcessingState(
        progress: 0.4,
        steps: _update(steps, 0, TextToSignStepStatus.done),
        currentStage: 'simplifying',
      ));

      // ── Step 2: Matching ────────────────────────────────────────────
      emit(TextToSignProcessingState(
        progress: 0.6,
        steps: _update(steps, 0, TextToSignStepStatus.done)
            ..[1] = steps[1].copyWith(status: TextToSignStepStatus.inProgress),
        currentStage: 'matching',
      ));
      await Future.delayed(const Duration(milliseconds: 600));

      // ── API Call ────────────────────────────────────────────────────
      emit(TextToSignProcessingState(
        progress: 0.8,
        steps: _update(steps, 1, TextToSignStepStatus.done),
        currentStage: 'matching',
      ));

      final result = await convertTextToSignUseCase(event.text);

      // ── Step 3: Done ────────────────────────────────────────────────
      final finalSteps = _update(steps, 2, TextToSignStepStatus.done);
      emit(TextToSignProcessingState(
        progress: 1.0,
        steps: finalSteps,
        currentStage: 'done',
      ));
      await Future.delayed(const Duration(milliseconds: 300));

      emit(TextToSignResultState(signVideo: result));

    } catch (e) {
      emit(TextToSignErrorState(
        message: 'تعذر تحويل النص، تحقق من الاتصال وحاول مرة أخرى',
      ));
    }
  }

  void _onReset(ResetTextToSignEvent event, Emitter<TextToSignState> emit) {
    emit(TextToSignIdleState());
  }

  Future<void> _onDownload(
    DownloadVideoEvent event,
    Emitter<TextToSignState> emit,
  ) async {
    // TODO: Implement download if needed
  }

  List<TextToSignStep> _update(
    List<TextToSignStep> steps,
    int index,
    TextToSignStepStatus status,
  ) {
    return List.generate(
      steps.length,
      (i) => i == index ? steps[i].copyWith(status: status) : steps[i],
    );
  }
}