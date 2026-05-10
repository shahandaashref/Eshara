import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_word_bloc_state_event.dart';

/// [BLoC] — AddWordBloc
/// بيدير حالات صفحة إضافة كلمة جديدة
class AddWordBloc extends Bloc<AddWordEvent, AddWordState> {
  AddWordBloc() : super(AddWordIdleState()) {
    on<PickVideoEvent>(_onPickVideo);
    on<SubmitWordEvent>(_onSubmit);
    on<CancelUploadEvent>(_onCancel);
  }

  /// [_onPickVideo] — بيحاكي اختيار فيديو من الاستوديو
  /// TODO: استبدل بـ image_picker أو file_picker حقيقي
  Future<void> _onPickVideo(PickVideoEvent event, Emitter<AddWordState> emit) async {
    await Future.delayed(const Duration(milliseconds: 500));
    emit(VideoPickedState(
      videoPath: '/mock/path/video.mp4',
      videoName: 'video_sign.mp4',
    ));
  }

  /// [_onSubmit] — بيحفظ الكلمة الجديدة ويبعتها للـ API
  /// TODO: استبدل بـ use case حقيقي
  Future<void> _onSubmit(SubmitWordEvent event, Emitter<AddWordState> emit) async {
    emit(AddWordLoadingState());
    await Future.delayed(const Duration(seconds: 2));
    emit(AddWordSuccessState());
  }

  /// [_onCancel] — بيرجع للـ idle state ويمسح الفيديو المختار
  void _onCancel(CancelUploadEvent event, Emitter<AddWordState> emit) {
    emit(AddWordIdleState());
  }
}
