import 'package:eshara/Core/Helper/theme.dart';
import 'package:eshara/Core/di/injection_container.dart';
import 'package:eshara/current_user_store.dart';
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
import 'package:eshara/features/addword/UI/Screens/add_word_page.dart';
import 'package:eshara/features/admin/UI/bloc/admin_bloc.dart';
import 'package:eshara/features/admin/UI/Screens/admin_categories_page.dart';
import 'package:eshara/features/admin/UI/Screens/admin_dashboard_page.dart';
import 'package:eshara/features/admin/UI/Screens/admin_requests_page.dart';
import 'package:eshara/features/admin/UI/Screens/admin_words_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// قائمة بأسماء المسارات التي تتطلب صلاحيات الأدمن
const List<String> _adminRoutes = [
  '/admin_dashboard',
  '/admin_categories',
  '/admin_words',
  '/admin_requests',
];

/// [Widget] — AuthWrapper
/// هذا الويدجت هو نقطة الدخول الأولى للتطبيق.
/// وظيفته هي التحقق من حالة تسجيل الدخول وتوجيه المستخدم للصفحة المناسبة.
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = CurrentUserStore.getCurrentUser();

    // إذا لم يكن المستخدم مسجلاً دخوله، يتم توجيهه لصفحة تسجيل الدخول
    if (currentUser == null) {
      return const LoginPage();
    }

    // إذا كان المستخدم "admin"، يتم توجيهه للوحة تحكم الأدمن
    if (currentUser.role == 'Admin' || currentUser.role == 'admin') {
      return const AdminDashboardPage();
    }

    // إذا كان مستخدماً عادياً، يتم توجيهه للصفحة الرئيسية
    return const MainPage();
  }
}

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

        // AdminBloc
        // تم تعديل طريقة الإنشاء مؤقتاً لتجنب خطأ حقن الاعتماديات
        BlocProvider<AdminBloc>(create: (_) => sl<AdminBloc>()),
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
        // نستخدم Builder هنا لضمان أن AuthWrapper يحصل على context صحيح
        // يكون "تحت" MaterialApp في شجرة الويدجت.
        // هذا يحل مشكلة الوصول للـ BLoC Providers من الصفحات التي يعرضها AuthWrapper.
        initialRoute: '/admin_dashboard', // تم تعديل المسار الافتراضي ليكون لوحة تحكم الأدمن
        routes: {
          '/auth': (context) => const AuthWrapper(),
          '/home': (context) => HomePage(), // تم التعديل ليشير إلى MainPage
          // تم حذف مسارات المصادقة الأولية من هنا لأن AuthWrapper هو المسؤول عنها
          '/register': (context) => RegisterPage(),
          '/login': (context) => LoginPage(),
          '/reset_password': (context) => ResetPasswordPage(),
          '/forget_password': (context) => ForgetPasswordPage(),
          // تم حذف '/verify_email' من هنا لأنه يُدار عبر onGenerateRoute
          '/signtotext': (context) => SignToTextPage(),
          '/texttosign': (context) => TextToSignPage(),
          '/profile': (context) => ProfilePage(),
          '/admin_dashboard': (context) => const AdminDashboardPage(),
          '/admin_categories': (context) => const AdminCategoriesPage(),
          '/admin_words': (context) => const AdminWordsPage(),
          '/admin_requests': (context) => const AdminRequestsPage(),
          '/add_word': (context) => AddWordPage(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/verify_email') {
            // جعل الكود أكثر أمانًا للتعامل مع الوسائط
            if (settings.arguments is String) {
              final email = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => VerifyEmailPage(email: email),
              );
            }
            // في حالة عدم تمرير البريد الإلكتروني، يتم عرض صفحة خطأ
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                body: Center(
                  child: Text(
                    'خطأ: لم يتم توفير البريد الإلكتروني لصفحة التحقق.',
                  ),
                ),
              ),
            );
          }
          return null; // إذا لم يتطابق أي شرط، دع `routes` يتعامل مع المسار
        },
        //home:RegisterPage(),
      ),
    );
  }
}
