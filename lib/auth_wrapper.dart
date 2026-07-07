import 'package:flutter/material.dart';
import 'package:eshara/current_user_store.dart';
import 'package:eshara/features/Authentication/ui/Screens/login_page.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _hasNavigated = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // ✅ استخدم didChangeDependencies بدل build
    // ده بيتنادي بعد ما الـ build يخلص
    if (!_hasNavigated) {
      _hasNavigated = true;
      _checkAuthAndNavigate();
    }
  }

  void _checkAuthAndNavigate() {
    final store = CurrentUserStore.instance;
    
    print('🔍 Checking auth state...');
    print('  📝 Is logged in: ${store.isLoggedIn}');
    print('  🎭 Is admin: ${store.isAdmin}');

    // ✅ استخدم Future.delayed عشان تتأكد إن الـ build خلص
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      
      if (!store.isLoggedIn) {
        print('🔴 No user found, redirecting to LoginPage');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      } else if (store.isAdmin) {
        print('👑 User is ADMIN, redirecting to AdminDashboardPage');
        Navigator.of(context).pushReplacementNamed('/admin_dashboard');
      } else {
        print('👤 User is NORMAL, redirecting to MainPage');
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ رجع Splash Screen أو Loading بدل ما ترجع Widget مختلف
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}