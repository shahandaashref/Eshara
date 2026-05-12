import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/convert_text_to_sign.dart';
import 'text_to_sign_state_event.dart';

/// [BLoC] — TextToSignBloc
/// بيدير الـ 3 states: idle → processing → result / error
class TextToSignBloc extends Bloc<TextToSignEvent, TextToSignState> {
  final ConvertTextToSignUseCase convertTextToSignUseCase;

  TextToSignBloc({required this.convertTextToSignUseCase})
      : super(TextToSignIdleState()) {
    on<ConvertTextEvent>(_onConvert);
    on<ResetTextToSignEvent>(_onReset);
    on<DownloadVideoEvent>(_onDownload);
  }

  /// [_onConvert] — بيمشي على الخطوات الثلاثة مع progress
  /// وبعدين بيكلم الـ use case ويـ emit النتيجة
  Future<void> _onConvert(
      ConvertTextEvent event, Emitter<TextToSignState> emit) async {
    // الخطوات الثلاثة اللي بتظهر في الـ UI
    final steps = [
      const TextToSignStep(
          label: 'تحليل بنية الإشارة',
          status: TextToSignStepStatus.pending),
      const TextToSignStep(
          label: 'تحويل النص إلى Gloss',
          status: TextToSignStepStatus.pending),
      const TextToSignStep(
          label: 'إنشاء رسوم متحركة ثلاثية الأبعاد',
          status: TextToSignStepStatus.pending),
    ];

    // ── Step 1 ────────────────────────────────────────────────────────────
    emit(TextToSignProcessingState(
      progress: 0.1,
      steps: _update(steps, 0, TextToSignStepStatus.inProgress),
    ));
    await Future.delayed(const Duration(milliseconds: 900));

    emit(TextToSignProcessingState(
      progress: 0.3,
      steps: _update(steps, 0, TextToSignStepStatus.done),
    ));
    await Future.delayed(const Duration(milliseconds: 400));

    // ── Step 2 ────────────────────────────────────────────────────────────
    final s2 = _update(steps, 0, TextToSignStepStatus.done);
    emit(TextToSignProcessingState(
      progress: 0.5,
      steps: _update(s2, 1, TextToSignStepStatus.inProgress),
    ));
    await Future.delayed(const Duration(milliseconds: 900));

    final s3 = _update(s2, 1, TextToSignStepStatus.done);
    emit(TextToSignProcessingState(progress: 0.7, steps: s3));
    await Future.delayed(const Duration(milliseconds: 400));

    // ── Step 3 ────────────────────────────────────────────────────────────
    final s4 = _update(s3, 2, TextToSignStepStatus.inProgress);
    emit(TextToSignProcessingState(progress: 0.85, steps: s4));
    await Future.delayed(const Duration(milliseconds: 900));

    // ── API Call ──────────────────────────────────────────────────────────
    try {
      final result = await convertTextToSignUseCase(event.text);
      emit(TextToSignResultState(signVideo: result));
    } catch (e) {
      emit(TextToSignErrorState(
          message: 'تعذر التحويل، تحقق من الاتصال وحاول مرة أخرى'));
    }
  }

  /// [_onReset] — بيرجع للـ idle state
  void _onReset(ResetTextToSignEvent event, Emitter<TextToSignState> emit) {
    emit(TextToSignIdleState());
  }

  /// [_onDownload] — بيتعامل مع حدث التنزيل
  /// TODO: استبدل بـ dio downloader حقيقي
  Future<void> _onDownload(
      DownloadVideoEvent event, Emitter<TextToSignState> emit) async {
    // هيفضل في نفس الـ result state — بس ممكن تضيف snackbar من الـ UI
  }

  /// [_update] — helper بيرجع list جديدة مع تغيير status خطوة معينة بس
  List<TextToSignStep> _update(
      List<TextToSignStep> steps, int index, TextToSignStepStatus status) {
    return List.generate(
      steps.length,
      (i) => i == index ? steps[i].copyWith(status: status) : steps[i],
    );
  }
}
