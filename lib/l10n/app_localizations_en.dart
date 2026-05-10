// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navCamera => 'Camera';

  @override
  String get navLibrary => 'Library';

  @override
  String get navProfile => 'Profile';

  @override
  String get appName => 'Eshara';

  @override
  String get welcomeMessage => 'Welcome';

  @override
  String get welcomeSubtitle => 'What would you like to translate today?';

  @override
  String get signToText => 'Sign to Text';

  @override
  String get signToTextDesc =>
      'Point the camera at a sign and we will translate it.';

  @override
  String get textToSign => 'Text to Sign';

  @override
  String get textToSignDesc =>
      'Type text and we will convert it to an interactive sign.';

  @override
  String get tagInstant => 'Instant';

  @override
  String get tagAI => 'AI';

  @override
  String get tagInteractive => 'Interactive';

  @override
  String get tagDailyActivity => 'Daily Activity';

  @override
  String get simulatedHandSign => 'Hand sign';

  @override
  String get simulatedTranslation =>
      'My name is , I study at Beni Suef University, and I am in my final year';
}
