class CurrentUserStore {
  CurrentUserStore._();

  static final CurrentUserStore instance = CurrentUserStore._();

  String _name = '';
  String _email = '';
  String _role = '';

  void setUser({required String name, required String email, String? role}) {
    _name = name;
    _email = email;
    _role = role?.trim() ?? '';
  }

  void clear() {
    _name = '';
    _email = '';
    _role = '';
  }

  String get name => _name;
  String get email => _email;
  String get role => _role;

  bool get hasUser => _name.isNotEmpty || _email.isNotEmpty;
}
