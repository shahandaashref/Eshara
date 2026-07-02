/// [Model] — يمثل بيانات المستخدم الحالي المحفوظة في الذاكرة
class CurrentUser {
  final String name;
  final String email;
  final String? role;

  CurrentUser({required this.name, required this.email, this.role});
}

/// [Singleton] — مخزن مؤقت لبيانات المستخدم الحالي أثناء استخدام التطبيق
///
/// يعمل هذا الكلاس كمخزن وحيد (Singleton) يمكن الوصول إليه من أي مكان
/// في التطبيق للاحتفاظ ببيانات المستخدم بعد تسجيل الدخول.
class CurrentUserStore {
  // --- Singleton Boilerplate ---
  static final CurrentUserStore _instance = CurrentUserStore._internal();
  factory CurrentUserStore() => _instance;
  CurrentUserStore._internal();
  // -----------------------------

  CurrentUser? _currentUser;

  /// دالة لتخزين بيانات المستخدم عند تسجيل الدخول
  void setUser({required String name, required String email, String? role}) {
    _currentUser = CurrentUser(name: name, email: email, role: role);
  }

  /// دالة لجلب دور المستخدم الحالي
  String? getRole() {
    return _currentUser?.role;
  }

  /// دالة ثابتة لجلب بيانات المستخدم كاملة
  static CurrentUser? getCurrentUser() {
    return _instance._currentUser;
  }

  /// دالة لجلب بيانات المستخدم كاملة
  CurrentUser? getUser() {
    return _currentUser;
  }

  /// دالة لمسح بيانات المستخدم عند تسجيل الخروج
  void clear() {
    _currentUser = null;
  }

  /// للتحقق مما إذا كان هناك مستخدم مسجل دخوله حالياً
  bool get isLoggedIn => _currentUser != null;
}
