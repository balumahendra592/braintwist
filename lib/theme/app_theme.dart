import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary    = Color(0xFF7C3AED);
  static const Color primaryLight = Color(0xFFEDE9FE);
  static const Color secondary  = Color(0xFF10B981);
  static const Color amber      = Color(0xFFF59E0B);
  static const Color danger     = Color(0xFFEF4444);
  static const Color bg         = Color(0xFFF7F3FF);
  static const Color surface    = Color(0xFFFFFFFF);
  static const Color textPrimary   = Color(0xFF1B0A3A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color border     = Color(0xFFE5E0F5);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      surface: bg,
    ),
    fontFamily: 'Nunito',
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B0A3A),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}