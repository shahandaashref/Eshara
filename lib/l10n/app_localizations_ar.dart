// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navCamera => 'الكاميرا';

  @override
  String get navLibrary => 'المكتبة';

  @override
  String get navProfile => 'حسابي';

  @override
  String get appName => 'إشارة';

  @override
  String get welcomeMessage => 'مرحباً بك';

  @override
  String get welcomeSubtitle => 'ماذا تريد أن تترجم اليوم؟';

  @override
  String get signToText => 'ترجمة الإشارة إلى نص';

  @override
  String get signToTextDesc => 'قم بتوجيه الكاميرا للإشارة وسنقوم بترجمتها.';

  @override
  String get textToSign => 'ترجمة النص إلى إشارة';

  @override
  String get textToSignDesc => 'اكتب النص وسنقوم بتحويله إلى إشارة تفاعلية.';

  @override
  String get tagInstant => 'فوري';

  @override
  String get tagAI => 'ذكاء اصطناعي';

  @override
  String get tagInteractive => 'تفاعلي';

  @override
  String get tagDailyActivity => 'نشاط يومي';

  @override
  String get simulatedHandSign => 'إشارة يد';

  @override
  String get simulatedTranslation =>
      'أنا اسمي  وأدرس في جامعة باي سويف، وفي السنة الأخيرة لي';
}
