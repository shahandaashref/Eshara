/// [Events] — AddWordEvent
abstract class AddWordEvent {}

/// بيتبعت لما المستخدم يضغط "إضافة"
class SubmitWordEvent extends AddWordEvent {
  final String word;
  final String? description;
  final String? videoPath;
  SubmitWordEvent({required this.word, this.description, this.videoPath});
}

/// بيتبعت لما المستخدم يختار فيديو من الاستوديو
class PickVideoEvent extends AddWordEvent {}

/// بيتبعت لما المستخدم يضغط "إلغاء العملية"
class CancelUploadEvent extends AddWordEvent {}

/// [States] — AddWordState
abstract class AddWordState {}

/// الحالة الأولى — الـ form فاضي جاهز للإدخال
class AddWordIdleState extends AddWordState {}

/// جاري رفع الفيديو أو حفظ الكلمة
class AddWordLoadingState extends AddWordState {}

/// تم اختيار فيديو — بيعرض اسمه في الـ UI
class VideoPickedState extends AddWordState {
  final String videoPath;
  final String videoName;
  VideoPickedState({required this.videoPath, required this.videoName});
}

/// تمت الإضافة بنجاح
class AddWordSuccessState extends AddWordState {}

/// حصل خطأ
class AddWordErrorState extends AddWordState {
  final String message;
  AddWordErrorState({required this.message});
}
