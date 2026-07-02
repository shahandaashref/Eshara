class UserEntity {
  final String email;
  final String? fullname;
  final String? token;
  final String role; // تمت إضافة خاصية الدور

  UserEntity({
    required this.email,
    this.fullname,
    this.token,
    this.role = 'User', // قيمة افتراضية لضمان الأمان
  });
}
