import 'dart:async';
import 'package:eshara/features/SignToText/Domain/usecases/translate_sign.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sign_event.dart';
import 'sign_state.dart';

class SignBloc extends Bloc<SignEvent, SignState> {
  final TranslateSignUseCase translateSignUseCase;

  SignBloc({required this.translateSignUseCase}) : super(SignIdleState()) {
    on<StartRecordingEvent>(_onStartRecording);
    on<StopRecordingEvent>(_onStopRecording);
    on<CancelRecordingEvent>(_onCancel);
    on<ResetEvent>(_onReset);
  }

  void _onStartRecording(StartRecordingEvent event, Emitter<SignState> emit) {
    emit(SignRecordingState());
  }

  Future<void> _onStopRecording(
    StopRecordingEvent event,
    Emitter<SignState> emit,
  ) async {
    // الخطوات الثلاثة اللي في الـ UI
    final steps = [
      const ProcessingStep(
        label: 'تحليل بنية الإشارة',
        status: StepStatus.pending,
      ),
      const ProcessingStep(
        label: 'تحويل إلى Gloss إلى نص',
        status: StepStatus.pending,
      ),
      const ProcessingStep(label: 'إنشاء النص', status: StepStatus.pending),
    ];

    // Step 1
    emit(
      SignProcessingState(
        progress: 0.1,
        steps: _updateStep(steps, 0, StepStatus.inProgress),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 800));

    emit(
      SignProcessingState(
        progress: 0.3,
        steps: _updateStep(steps, 0, StepStatus.done),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 400));

    // Step 2
    final steps2 = _updateStep(steps, 0, StepStatus.done);
    emit(
      SignProcessingState(
        progress: 0.45,
        steps: _updateStep(steps2, 1, StepStatus.inProgress),
      ),
    );
    await Future.delayed(const Duration(milliseconds: 800));

    final steps3 = _updateStep(steps2, 1, StepStatus.done);
    emit(SignProcessingState(progress: 0.7, steps: steps3));
    await Future.delayed(const Duration(milliseconds: 400));

    // Step 3
    final steps4 = _updateStep(steps3, 2, StepStatus.inProgress);
    emit(SignProcessingState(progress: 0.85, steps: steps4));
    await Future.delayed(const Duration(milliseconds: 800));

    // Call use case
    final result = await translateSignUseCase(event.videoPath);

    result.fold(
      // في حالة الفشل (الجانب الأيسر)
      (failure) => emit(SignErrorState(message: failure.message)),
      // في حالة النجاح (الجانب الأيمن)
      (translation) => emit(SignResultState(translation: translation)),
    );
  }

  void _onCancel(CancelRecordingEvent event, Emitter<SignState> emit) {
    emit(SignIdleState());
  }

  void _onReset(ResetEvent event, Emitter<SignState> emit) {
    emit(SignIdleState());
  }

  List<ProcessingStep> _updateStep(
    List<ProcessingStep> steps,
    int index,
    StepStatus status,
  ) {
    return List.generate(
      steps.length,
      (i) => i == index ? steps[i].copyWith(status: status) : steps[i],
    );
  }
}
