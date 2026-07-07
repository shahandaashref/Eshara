import 'dart:convert';
import 'package:eshara/Core/utils/jwt_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// [Model] — يمثل بيانات المستخدم الحالي
class CurrentUser {
  final String name;
  final String email;
  final String? role;
  final String? token;
  final DateTime? expiresAt;

  CurrentUser({
    required this.name,
    required this.email,
    this.role,
    this.token,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role ?? 'user',
      'token': token,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    return CurrentUser(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      token: json['token'],
      expiresAt: json['expiresAt'] != null
          ? DateTime.tryParse(json['expiresAt'])
          : null,
    );
  }

  /// ✅ هل التوكن خلصت؟ (مع buffer 5 دقايق)
  bool get isTokenExpired {
    if (expiresAt == null) {
      // لو مفيش expiresAt، نفحص من الـ JWT token نفسه
      if (token != null) {
        try {
          final decoded = JwtHelper.decodeToken(token!);
          final exp = decoded['exp'];
          if (exp != null) {
            final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
            return DateTime.now().isAfter(
              expiryDate.subtract(const Duration(minutes: 5)),
            );
          }
        } catch (e) {
          print('❌ Error checking token expiry: $e');
        }
      }
      return false;
    }
    return DateTime.now().isAfter(
      expiresAt!.subtract(const Duration(minutes: 5)),
    );
  }
}

/// [Singleton] — مخزن دائم لبيانات المستخدم
class CurrentUserStore extends ChangeNotifier {
  static final CurrentUserStore _instance = CurrentUserStore._internal();
  factory CurrentUserStore() => _instance;
  static CurrentUserStore get instance => _instance;
  CurrentUserStore._internal();

  CurrentUser? _currentUser;
  String? _token;
  SharedPreferences? _prefs;

  /// ✅ Callback لما التوكن تخلص
  VoidCallback? onTokenExpired;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    if (_prefs == null) return;

    final userJson = _prefs!.getString('current_user');
    final token = _prefs!.getString('auth_token');

    if (token != null && token.isNotEmpty) {
      _token = token;
    }

    if (userJson != null && userJson.isNotEmpty) {
      try {
        final Map<String, dynamic> data =
            Map<String, dynamic>.from(jsonDecode(userJson));
        _currentUser = CurrentUser.fromJson(data);
      } catch (e) {
        print('❌ Error loading user from storage: $e');
      }
    }
  }

  Future<void> _saveToStorage() async {
    if (_prefs == null) return;

    if (_currentUser != null) {
      final userJson = jsonEncode(_currentUser!.toJson());
      await _prefs!.setString('current_user', userJson);

      if (_token != null && _token!.isNotEmpty) {
        await _prefs!.setString('auth_token', _token!);
      } else {
        await _prefs!.remove('auth_token');
      }
    } else {
      await _prefs!.remove('current_user');
      await _prefs!.remove('auth_token');
    }
  }

  /// ✅ استخراج وقت الانتهاء من التوكن JWT
  DateTime? _extractExpiresAt(String token) {
    try {
      final decoded = JwtHelper.decodeToken(token);
      final exp = decoded['exp'];
      if (exp != null) {
        return DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      }
    } catch (e) {
      print('❌ Error extracting exp from token: $e');
    }
    return null;
  }

  Future<void> setUserFromToken(String token) async {
    _token = token;

    final name = JwtHelper.getNameFromToken(token) ?? 'مستخدم';
    final email = JwtHelper.getEmailFromToken(token) ?? '';
    final role = JwtHelper.getRoleFromToken(token) ?? 'user';
    final expiresAt = _extractExpiresAt(token);

    _currentUser = CurrentUser(
      name: name,
      email: email,
      role: role,
      token: token,
      expiresAt: expiresAt,
    );

    await _saveToStorage();
    notifyListeners();

    print('✅ User stored from token: $email');
    print('⏰ Token expires at: $expiresAt');
  }

  Future<void> setUser({
    required String name,
    required String email,
    String? role,
    String? token,
  }) async {
    _token = token;

    final String finalRole = role ?? 'user';
    final expiresAt = token != null ? _extractExpiresAt(token) : null;

    _currentUser = CurrentUser(
      name: name,
      email: email,
      role: finalRole,
      token: token,
      expiresAt: expiresAt,
    );

    await _saveToStorage();
    notifyListeners();

    print('✅ User stored: $email, Role: $finalRole');
    print('⏰ Token expires at: $expiresAt');
  }

  /// ✅ تحديث التوكن فقط
  Future<void> updateToken(String newToken) async {
    print('🔄 Updating token...');
    _token = newToken;
    final expiresAt = _extractExpiresAt(newToken);

    if (_currentUser != null) {
      _currentUser = CurrentUser(
        name: _currentUser!.name,
        email: _currentUser!.email,
        role: _currentUser!.role,
        token: newToken,
        expiresAt: expiresAt,
      );
    }

    await _saveToStorage();
    notifyListeners();
    print('✅ Token updated, expires at: $expiresAt');
  }

  String? getRole() {
    if (_currentUser?.role != null) {
      return _currentUser?.role;
    }
    if (_token != null) {
      return JwtHelper.getRoleFromToken(_token!);
    }
    return null;
  }

  CurrentUser? getCurrentUser() {
    return _currentUser;
  }

  static CurrentUser? getCurrentUserStatic() {
    return _instance._currentUser;
  }

  /// ✅ التحقق من التوكن مع فحص الانتهاء
  String? getToken() {
    // فحص مباشر
    if (_currentUser?.isTokenExpired ?? false) {
      print('⏰ Token is expired! Triggering logout...');
      _handleTokenExpired();
      return null;
    }

    // فحص من SharedPreferences
    if (_prefs != null) {
      final token = _prefs!.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        // نفحص لو الـ token منفصل عن _currentUser
        if (_token == null || _token != token) {
          _token = token;
        }
        return token;
      }
    }

    return _token;
  }

  /// ✅ فحص مباشر إن التوكن خلصت
  bool get isTokenExpired => _currentUser?.isTokenExpired ?? false;

  /// ✅ فحص التوكن قبل أي عملية
  bool get isTokenValid {
    final token = getToken();
    return token != null && token.isNotEmpty && !isTokenExpired;
  }

  /// ✅ معالجة انتهاء التوكن
  void _handleTokenExpired() {
    // نعمل clear في background
    clear();
    // نادي الـ callback
    Future.delayed(Duration.zero, () {
      onTokenExpired?.call();
    });
  }

  Future<void> clear() async {
    _currentUser = null;
    _token = null;
    if (_prefs != null) {
      await _prefs!.remove('current_user');
      await _prefs!.remove('auth_token');
    }
    notifyListeners();
    print('🗑️ User and token cleared');
  }

  bool get isLoggedIn {
    final token = getToken();
    return token != null && token.isNotEmpty;
  }

  bool get isAdmin {
    if (_currentUser?.role != null) {
      final role = _currentUser!.role!.toLowerCase().trim();
      const adminRoles = ['admin', 'administrator', 'super_admin', 'مدير'];
      return adminRoles.contains(role);
    }

    if (_token != null) {
      final role = JwtHelper.getRoleFromToken(_token!);
      if (role != null) {
        const adminRoles = ['admin', 'administrator', 'super_admin', 'مدير'];
        return adminRoles.contains(role.toLowerCase().trim());
      }
    }

    return false;
  }

  bool get isNormalUser {
    return isLoggedIn && !isAdmin;
  }
}