/// [Entity] — User
/// بيمثل بيانات المستخدم في الـ domain layer.
/// مفيش فيه أي logic أو dependencies — pure Dart class.
class User {
  final String? id;
  final String fullName;
  final String email;
  final String? avatarUrl;   // ممكن يكون null لو مفيش صورة
  final String? role;        // إضافة الدور لنموذج المستخدم
  final bool notificationsEnabled;

  User({
    //required
    this.id,
    required this.fullName,
    required this.email,
    this.role,
    this.avatarUrl,
    this.notificationsEnabled = true,
  });

  /// [copyWith] — بترجع نسخة جديدة من الـ User مع تغيير الـ fields المحددة بس
  User copyWith({
    String? fullName,
    String? email,
    String? avatarUrl,
    String? role,
    bool? notificationsEnabled,
  }) {
    return User(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
