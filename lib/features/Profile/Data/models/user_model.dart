import 'package:eshara/features/Profile/Domin/entities/user.dart';


/// [Model] — UserModel
/// بيورث من [User] ويضيف fromJson/toJson للتعامل مع الـ API
class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    super.notificationsEnabled,
  });

  /// [fromJson] — بيحول الـ API response لـ UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
    );
  }

  /// [toJson] — بيحول الـ UserModel لـ Map يتبعت للـ API
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'avatar_url': avatarUrl,
    'notifications_enabled': notificationsEnabled,
  };
}
