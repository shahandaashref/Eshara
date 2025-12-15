import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

class EsharaTheme {
  static const Color primarygrean = Color(0xff00B894);
  static const Color white = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xff192A56);
  static const Color blueBlured = Color.fromRGBO(25, 42, 86, 0.6);
  static const Color darkGreen = Color(0xff08846C);
  static const Color lightGreen = Color(0xff86E9D6);



  static const ColorScheme _colorscheme = ColorScheme(
    brightness: Brightness.light,
    primary: primarygrean,
    onPrimary: white,
    secondary: secondary,
    onSecondary: primarygrean,
    error: white,
    onError: primarygrean,
    surface: darkGreen,
    onSurface: lightGreen,
  );

  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: secondary,
        letterSpacing: -0.5,
      ),

      // Heading two - 24px, Newsreader display, Medium
      displayMedium: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: blueBlured,
        letterSpacing: -0.3,
      ),

      // Heading three - 20px, Newsreader display, Medium
      displaySmall: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: white,
        letterSpacing: -0.2,
      ),

      // Heading four - 16px, Newsreader display, Medium
      headlineLarge: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: white,
      ),

      // Heading five - 12px, Karla, Bold
      headlineMedium: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: white,
        letterSpacing: 0.5,
      ),

      // Body medium - 14px, Karla, Regular
      bodyMedium: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
        letterSpacing: 0.25,
      ),

      // Body small - 12px, Karla, Regular
      bodySmall: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: primarygrean,
        letterSpacing: 0.4,
      ),

      // Additional text styles
      titleLarge: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),

      titleMedium: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: white,
      ),

      titleSmall: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: primarygrean,
      ),

      labelLarge: TextStyle(
        fontFamily: 'sans-serif',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: white,
        letterSpacing: 0.1,
      ),

      labelMedium: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: primarygrean,
        letterSpacing: 0.5,
      ),

      labelSmall: TextStyle(
        fontFamily: 'TenorSans',
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: primarygrean,
        letterSpacing: 0.5,
      ),
    );
  }

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: _colorscheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: white,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primarygrean,
          foregroundColor: white,
          shape: RoundedRectangleBorder(
            
            borderRadius:  BorderRadius.circular(10),
            
          ),
          //padding: EdgeInsets.symmetric(horizontal:  40,vertical: 10),
          textStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
          side: BorderSide(
            color: primarygrean
          )

        ),
      ),
    );
  }
}
