import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/di/injection_container.dart';
import 'package:eshara/features/Authentication/UI/Screens/forget_password.dart';
import 'package:eshara/features/Authentication/UI/Screens/login_page.dart';
import 'package:eshara/features/Authentication/UI/Screens/register_page.dart';
import 'package:eshara/features/Authentication/UI/Screens/reset_password_page.dart';
import 'package:eshara/features/Authentication/UI/Screens/verify_email_page.dart';
import 'package:eshara/features/Home/UI/Screens/home_page.dart';
import 'package:eshara/features/Home/UI/Screens/main_page.dart';
import 'package:eshara/features/Authentication/UI/bloc/auth_bloc.dart';
import 'package:eshara/features/Profile/Ui/Screens/profile_page.dart';
import 'package:eshara/features/Profile/Ui/bloc/profile_bloc.dart';
import 'package:eshara/features/Dictionary/Ui/bloc/dictionary_bloc.dart';
import 'package:eshara/features/Profile/Ui/bloc/profile_event.dart';
import 'package:eshara/features/SignToText/UI/Screens/sign_to_text_page.dart';
import 'package:eshara/features/SignToText/UI/bloc/sign_bloc.dart';
import 'package:eshara/features/Text_to_sign/Ui/Screens/text_to_sign_page.dart';
import 'package:eshara/features/Text_to_sign/Ui/bloc/text_to_sign_bloc.dart';
import 'package:eshara/features/admin/UI/Screens/admin_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ProfileBloc — متاح في كل الصفحات
        // بنبعت LoadProfileEvent فوراً عشان يجيب البيانات
        BlocProvider<ProfileBloc>(
          create: (_) => sl<ProfileBloc>()..add(LoadProfileEvent()),
        ),

        // SignBloc — registerFactory يعمل instance جديد كل مرة
        BlocProvider<SignBloc>(create: (_) => sl<SignBloc>()),
        // AuthBloc
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),

        // DictionaryBloc
        BlocProvider<DictionaryBloc>(create: (_) => sl<DictionaryBloc>()),
        
        // TextToSignBloc
        BlocProvider<TextToSignBloc>(create: (_) => sl<TextToSignBloc>()),
      ],
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
          '/': (context) => const MainPage(),
          '/home': (context) => HomePage(),
          '/register': (context) => RegisterPage(),
          '/login': (context) => LoginPage(),
          '/reset_password': (context) => ResetPasswordPage(),
          '/forget_password': (context) => ForgetPasswordPage(),
          '/verify_email': (context) => VerifyEmailPage(),
          '/signtotext': (context) => SignToTextPage(),
          '/texttosign': (context) => TextToSignPage(),
          '/profile': (context) => ProfilePage(),
          '/admin_dashboard': (context) => AdminDashboardPage(),
          

        },
        //home:RegisterPage(),
      ),
    );
  }
}
