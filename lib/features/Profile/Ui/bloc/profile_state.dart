import 'package:eshara/features/Profile/Domin/entities/user.dart';


abstract class ProfileState {}

/// الحالة الأولى — بيجيب البيانات
class ProfileLoadingState extends ProfileState {}

/// البيانات اتحملت بنجاح
class ProfileLoadedState extends ProfileState {
  final User user;
  ProfileLoadedState({required this.user});
}

/// بيتحدث (saving)
class ProfileUpdatingState extends ProfileState {
  final User user; // بنحتفظ بالـ user عشان الـ UI ما يختفيش
  ProfileUpdatingState({required this.user});
}

/// التحديث اتعمل بنجاح
class ProfileUpdatedState extends ProfileState {
  final User user;
  ProfileUpdatedState({required this.user});
}

/// تسجيل الخروج بنجاح — الـ UI هيروح لصفحة اللوجين
class ProfileLoggedOutState extends ProfileState {}

/// حصل خطأ
class ProfileErrorState extends ProfileState {
  final String message;
  final User? user; // بنحتفظ بالـ user لو الخطأ حصل بعد التحميل
  ProfileErrorState({required this.message, this.user});
}
