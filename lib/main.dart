import 'package:eshara/my_app.dart';
import 'package:flutter/material.dart';
import 'package:eshara/Core/di/injection_container.dart';
import 'package:eshara/current_user_store.dart';
import 'package:eshara/features/Authentication/ui/bloc/auth_bloc.dart';
import 'package:eshara/features/Authentication/ui/bloc/auth_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ init الـ dependencies
  await initDependencies();
  
  // ✅ init CurrentUserStore
  await CurrentUserStore.instance.init();
   // ✅ سجّل callback لما التوكن تخلص
  CurrentUserStore.instance.onTokenExpired = () {
    print('⏰ Token expired callback triggered!');
    // هنا ممكن تستخدم navigatorKey عشان توجّه للـ Login
  };

   // ✅ ضيف ده عشان تطبع الـ Stack Trace الكامل
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    // هيطبعلك كل حاجة بالتفصيل
  };
  
  runApp(const MyApp());
}