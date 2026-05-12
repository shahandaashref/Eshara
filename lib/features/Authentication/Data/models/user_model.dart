import '../../Domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.email,
    super.fullname,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      fullname: json['fullname'], // الاسم الكامل اللي جاي من الـ ASP.NET
      token: json['token'], // التوكن اللي جاي من الـ ASP.NET
    );
  }
}
