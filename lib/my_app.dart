import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/features/Authentication/UI/Screens/forget_password.dart';
import 'package:eshara/features/Authentication/UI/Screens/login_page.dart';
import 'package:eshara/features/Authentication/UI/Screens/register_page.dart';
import 'package:eshara/features/Home/UI/Screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        supportedLocales: [Locale('ar', 'AE'), Locale('en', '')],

        locale: Locale('ar', 'AE'),

        debugShowCheckedModeBanner: false,
        title: 'Eshara',
        theme: EsharaTheme.theme,
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(),
          '/register': (context) => RegisterPage(),
          '/login': (context) => LoginPage(),
          '/forget_password': (context) => ForgetPasswordPage(),
        },
        //home:RegisterPage(),
      ),
    );
  }
}
