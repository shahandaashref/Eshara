import 'package:flutter/material.dart';

class EsharaTheme {
  // ── Colors ────────────────────────────────────────────────────────────────
  static const Color primaryBlue  = Color(0xFF2563EB);
  static const Color primaryDark  = Color(0xFF192A56);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color white        = Color(0xFFFFFFFF);

  static const Color background     = Color(0xFFF8FAFF);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5FF);

  static const Color textPrimary   = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint      = Color(0xFF94A3B8);

  static const Color border  = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error   = Color(0xFFEF4444);

  static const Color navBackground = Color(0xFFFFFFFF);
  static const Color navSelected   = Color(0xFF2563EB);
  static const Color navUnselected = Color(0xFF94A3B8);

  // ── Gradients ─────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── ColorScheme ───────────────────────────────────────────────────────────
  static const ColorScheme _colorScheme = ColorScheme(
    brightness:  Brightness.light,
    primary:     primaryBlue,
    onPrimary:   white,
    secondary:   primaryDark,
    onSecondary: primaryBlue,
    error:       error,
    onError:     white,
    surface:     surface,
    onSurface:   textPrimary,
  );

  // ── TextTheme ─────────────────────────────────────────────────────────────
  static TextTheme get textTheme => const TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: textPrimary,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: textPrimary,
      letterSpacing: -0.3,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: textPrimary,
      letterSpacing: -0.2,
    ),
    headlineLarge: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: textPrimary,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: textPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: textSecondary,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 15,
      fontWeight: FontWeight.w400,
      color: textPrimary,
      height: 1.5,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: textSecondary,
      height: 1.5,
      letterSpacing: 0.25,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 11,
      fontWeight: FontWeight.w400,
      color: textHint,
      height: 1.4,
      letterSpacing: 0.4,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 15,
      fontWeight: FontWeight.w600,
      color: white,
      letterSpacing: 0.2,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: primaryBlue,
      letterSpacing: 0.3,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Cairo',
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: textHint,
      letterSpacing: 0.5,
    ),
  );

  // ── ThemeData ─────────────────────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    textTheme: textTheme,
    fontFamily: 'Cairo',
    scaffoldBackgroundColor: background,

    appBarTheme: const AppBarTheme(
      backgroundColor: surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textPrimary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        side: const BorderSide(color: primaryBlue),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: const BorderSide(color: primaryBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Cairo',
        fontSize: 13,
        color: textHint,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: border),
      ),
    ),
  );
}