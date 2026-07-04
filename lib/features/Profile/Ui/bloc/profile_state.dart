import 'package:eshara/features/Profile/Domain/entities/profile_entity.dart';

abstract class ProfileState {}

/// الحالة الأولية قبل أي عملية
class ProfileInitial extends ProfileState {}

/// جاري تحميل بيانات الملف الشخصي
class ProfileLoading extends ProfileState {}

/// البيانات اتحملت بنجاح
class ProfileLoaded extends ProfileState {
  final ProfileEntity profile;
  ProfileLoaded(this.profile);
}

/// جاري تحديث بيانات الملف الشخصي
class ProfileUpdating extends ProfileState {}

/// تم تحديث البيانات بنجاح
class ProfileUpdateSuccess extends ProfileState {}

/// تسجيل الخروج بنجاح — الـ UI هيروح لصفحة اللوجين
class ProfileLoggedOutState extends ProfileState {}

/// حصل خطأ
class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}
