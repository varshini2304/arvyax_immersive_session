import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color deepIndigo = Color(0xFF2B2F77);
  static const Color softLavender = Color(0xFFC9C7FF);
  static const Color calmBlue = Color(0xFF7A8CFF);
  static const Color mistGray = Color(0xFFF4F5F7);
  static const Color darkBackground = Color(0xFF0F1117);
  static const Color accentGlow = Color(0xFF9EA8FF);
  static const Color darkSurface = Color(0xFF171A25);
  static const Color darkCard = Color(0xFF1C2130);
}

class AmbienceUiTokens {
  static const double cardRadius = 38;
  static const double imageRadius = 38;
  static const double pillRadius = 999;

  static const List<Color> backgroundGradient = [
    Color(0xFF1D184A),
    Color(0xFF261D6F),
    Color(0xFF1B1545),
  ];

  static const Color glowCore = Color(0xFFB9A7FF);
  static const Color glowRing = Color(0xFF7A8CFF);

  static const List<Color> glassPanelGradient = [
    Color(0x9E2A2F76),
    Color(0xE01D235E),
  ];

  static const List<Color> primaryButtonGradient = [
    Color(0xFF676BEB),
    Color(0xFFC8B2FF),
  ];
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: AppColors.deepIndigo,
        secondary: AppColors.calmBlue,
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.mistGray,
    );

    final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
      headlineLarge: GoogleFonts.sora(
        fontSize: 38,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.6,
      ),
      headlineSmall: GoogleFonts.sora(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      ),
      titleLarge: GoogleFonts.dmSans(fontSize: 20, fontWeight: FontWeight.w600),
      titleMedium:
          GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.darkBackground,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.softLavender,
        secondary: AppColors.calmBlue,
        surface: AppColors.darkSurface,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
    );

    final textTheme = GoogleFonts.dmSansTextTheme(base.textTheme)
        .apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        )
        .copyWith(
          headlineLarge: GoogleFonts.sora(
            fontSize: 38,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.sora(
            fontSize: 30,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
            color: Colors.white,
          ),
          headlineSmall: GoogleFonts.sora(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          titleMedium: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
        );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
    );
  }
}
