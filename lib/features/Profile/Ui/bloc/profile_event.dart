import 'package:eshara/features/Profile/Domin/entities/user.dart';


abstract class ProfileEvent {}

/// بيتبعت لما الصفحة تفتح — بيجيب بيانات المستخدم
class LoadProfileEvent extends ProfileEvent {}

/// بيتبعت لما المستخدم يحفظ التعديلات في edit profile
class UpdateProfileEvent extends ProfileEvent {
  final User user;
  UpdateProfileEvent({required this.user});
}

/// بيتبعت لما المستخدم يضغط "تسجيل الخروج" ويأكد
class LogoutEvent extends ProfileEvent {}

/// بيتبعت لما المستخدم يغير الـ toggle بتاع الإشعارات
class ToggleNotificationsEvent extends ProfileEvent {
  final bool enabled;
  ToggleNotificationsEvent({required this.enabled});
}
