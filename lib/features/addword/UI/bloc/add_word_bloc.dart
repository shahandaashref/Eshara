import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eshara/features/addword/Domain/entities/add_word_request.dart';
import 'package:eshara/features/addword/Domain/usecases/submit_word_request_usecase.dart';
import 'package:eshara/features/addword/UI/bloc/add_word_bloc_state_event.dart';

/// [BLoC] — AddWordBloc
/// بيدير حالات صفحة إضافة كلمة جديدة
class AddWordBloc extends Bloc<AddWordEvent, AddWordState> {
  final SubmitWordRequestUseCase submitWordRequestUseCase;

  AddWordBloc({required this.submitWordRequestUseCase})
    : super(AddWordIdleState()) {
    on<PickVideoEvent>(_onPickVideo);
    on<SubmitWordEvent>(_onSubmit);
    on<CancelUploadEvent>(_onCancel);
  }

  Future<void> _onPickVideo(
    PickVideoEvent event,
    Emitter<AddWordState> emit,
  ) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

    if (pickedFile == null) return;

    emit(
      VideoPickedState(videoPath: pickedFile.path, videoName: pickedFile.name),
    );
  }

  Future<void> _onSubmit(
    SubmitWordEvent event,
    Emitter<AddWordState> emit,
  ) async {
    emit(AddWordLoadingState());

    final request = AddWordRequest(
      arabicMeaning: event.word,
      notes: event.description ?? '',
      videoPath: event.videoPath,
    );

    try {
      await submitWordRequestUseCase(request);
      emit(AddWordSuccessState());
    } catch (e) {
      emit(AddWordErrorState(message: e.toString()));
    }
  }

  void _onCancel(CancelUploadEvent event, Emitter<AddWordState> emit) {
    emit(AddWordIdleState());
  }
}
