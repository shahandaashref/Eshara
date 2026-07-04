import 'package:eshara/features/Profile/Domain/entities/profile_entity.dart';

class ProfileModel extends ProfileEntity {
  ProfileModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.role,
    required super.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
      role: json['role'] ?? 'regular_user',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }
}
