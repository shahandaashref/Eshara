/// [Entity] — User
/// بيمثل بيانات المستخدم في الـ domain layer.
/// مفيش فيه أي logic أو dependencies — pure Dart class.
class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;   // ممكن يكون null لو مفيش صورة
  final bool notificationsEnabled;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.notificationsEnabled = true,
  });

  /// [copyWith] — بترجع نسخة جديدة من الـ User مع تغيير الـ fields المحددة بس
  User copyWith({
    String? name,
    String? email,
    String? avatarUrl,
    bool? notificationsEnabled,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
