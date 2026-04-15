import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return _build(brightness: Brightness.light);
  }

  static ThemeData dark() {
    return _build(brightness: Brightness.dark);
  }

  static ThemeData _build({required Brightness brightness}) {
    const seedColor = Color(0xFF6D8DF7);
    final isDark = brightness == Brightness.dark;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
        ).copyWith(
          surface: isDark ? const Color(0xFF111827) : const Color(0xFFFFFFFF),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0B1220)
          : const Color(0xFFF4F7FB),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark
            ? const Color(0xFF0B1220)
            : const Color(0xFFF4F7FB),
        foregroundColor: isDark
            ? const Color(0xFFE5E7EB)
            : const Color(0xFF1B2430),
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: isDark ? const Color(0xFFE5E7EB) : const Color(0xFF1B2430),
        ),
      ),
      cardTheme: CardThemeData(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE9EEF7),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF111827) : Colors.white,
        hintStyle: TextStyle(
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF8A94A6),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE3E9F5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE3E9F5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF9AAEF9),
            width: 1.4,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? const Color(0xFF111827)
            : const Color(0xFF1F2937),
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
