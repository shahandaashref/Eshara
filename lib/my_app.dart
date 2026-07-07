import 'package:eshara/auth_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/di/injection_container.dart';
import 'package:eshara/current_user_store.dart';
import 'package:eshara/features/Authentication/ui/Screens/login_page.dart';
import 'package:eshara/features/Authentication/ui/Screens/register_page.dart';
import 'package:eshara/features/Authentication/ui/Screens/forget_password.dart';
import 'package:eshara/features/Authentication/ui/Screens/reset_password_page.dart';
import 'package:eshara/features/Authentication/ui/Screens/verify_email_page.dart';
import 'package:eshara/features/Home/ui/Screens/main_page.dart';
import 'package:eshara/features/Authentication/ui/bloc/auth_bloc.dart';
import 'package:eshara/features/Profile/ui/Screens/profile_page.dart';
import 'package:eshara/features/Profile/ui/bloc/profile_bloc.dart';
import 'package:eshara/features/Dictionary/ui/bloc/dictionary_bloc.dart';
import 'package:eshara/features/SignToText/ui/Screens/sign_to_text_page.dart';
import 'package:eshara/features/SignToText/ui/bloc/sign_bloc.dart';
import 'package:eshara/features/Text_to_sign/ui/Screens/text_to_sign_page.dart';
import 'package:eshara/features/Text_to_sign/ui/bloc/text_to_sign_bloc.dart';
import 'package:eshara/features/addword/ui/Screens/add_word_page.dart';
import 'package:eshara/features/admin/ui/bloc/admin_bloc.dart';
import 'package:eshara/features/admin/ui/Screens/admin_categories_page.dart';
import 'package:eshara/features/admin/ui/Screens/admin_dashboard_page.dart';
import 'package:eshara/features/admin/ui/Screens/admin_requests_page.dart';
import 'package:eshara/features/admin/ui/Screens/admin_words_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider<SignBloc>(create: (_) => sl<SignBloc>()),
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<DictionaryBloc>(create: (_) => sl<DictionaryBloc>()),
        BlocProvider<TextToSignBloc>(create: (_) => sl<TextToSignBloc>()),
        BlocProvider<AdminBloc>(create: (_) => sl<AdminBloc>()),
      ],
      child: ListenableBuilder(
        listenable: CurrentUserStore.instance,
        builder: (context, child) {
          return MaterialApp(
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
            // ✅ initialRoute ثابت — مش بيتغير
            initialRoute: '/auth',
            routes: {
              '/auth': (context) => const AuthWrapper(),
              '/home': (context) => const MainPage(),
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/reset_password': (context) => const ResetPasswordPage(),
              '/forget_password': (context) => const ForgetPasswordPage(),
              '/signtotext': (context) => const SignToTextPage(),
              '/texttosign': (context) => const TextToSignPage(),
              '/profile': (context) => const ProfilePage(),
              '/admin_dashboard': (context) => const AdminDashboardPage(),
              '/admin_categories': (context) => const AdminCategoriesPage(),
              '/admin_words': (context) => const AdminWordsPage(),
              '/admin_requests': (context) => const AdminRequestsPage(),
              '/add_word': (context) => const AddWordPage(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == '/verify_email') {
                if (settings.arguments is String) {
                  final email = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (_) => VerifyEmailPage(email: email),
                  );
                }
                return MaterialPageRoute(
                  builder: (_) => Scaffold(
                    body: Center(
                      child: Text('خطأ: لم يتم توفير البريد الإلكتروني لصفحة التحقق.'),
                    ),
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}