import 'package:eshara/features/Profile/Domain/entities/profile_entity.dart';

abstract class ProfileEvent {}

/// بيتبعت لما الصفحة تفتح — بيجيب بيانات المستخدم
class LoadProfileEvent extends ProfileEvent {}

/// يُرسل عند تحديث بيانات المستخدم
class UpdateProfileEvent extends ProfileEvent {
  final ProfileEntity profile;
  UpdateProfileEvent(this.profile);
}

/// بيتبعت لما المستخدم يضغط "تسجيل الخروج" ويأكد
class LogoutEvent extends ProfileEvent {}
