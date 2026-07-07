class CurrentUserStore {
  CurrentUserStore._();

  static final CurrentUserStore instance = CurrentUserStore._();

  String _name = '';
  String _email = '';
  String _role = '';
  String? _token;

  String? get token => _token;

  void setToken(String token) {
    _token = token;
  }


  void setUser({required String name, required String email, String? role, String? token}) {
    _name = name;
    _email = email;
    _role = role?.trim() ?? '';
    _token = token;

  }

  void clear() {
    _name = '';
    _email = '';
    _role = '';
    _token = '';
  }

  String get name => _name;
  String get email => _email;
  String get role => _role;
  bool get isAdmin => _role.toLowerCase().trim() == 'admin';
  bool get isNormalUser => !isAdmin;
  bool get isLoggedIn => _name.isNotEmpty || _email.isNotEmpty;

  bool get hasUser => _name.isNotEmpty || _email.isNotEmpty;
}
