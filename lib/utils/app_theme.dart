import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Costanti colori dell'applicazione
class AppColors {
  // Colori primari
  static const Color gold = Color(0xFFFFD700);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color amber = Color(0xFFFFC107);
  static const Color amberLight = Color(0xFFFFE082);

  // Sfondi
  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkerBackground = Color(0xFF16213E);
  static const Color darkestBackground = Color(0xFF0F3460);
  static const Color cardBackground = Color(0xFF252540);

  // Testi
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0B0);
  static const Color textMuted = Color(0xFF6B6B6B);

  // Stati
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);

  // Gradiente sfondo principale
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBackground, darkerBackground, darkestBackground],
  );
}

/// Stili di testo predefiniti
class AppTextStyles {
  // Numeri grandi (tabellone)
  static TextStyle numberLarge = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  // Numeri estratti (giganti per animazione)
  static TextStyle numberGiant = GoogleFonts.poppins(
    fontSize: 220,
    fontWeight: FontWeight.w900,
    color: AppColors.gold,
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.5),
        offset: const Offset(4, 4),
        blurRadius: 10,
      ),
      const Shadow(
        color: AppColors.goldDark,
        offset: Offset(2, 2),
        blurRadius: 0,
      ),
    ],
  );

  // Titolo app
  static TextStyle appTitle = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.gold,
    letterSpacing: 2,
  );

  // Titoli sezioni
  static TextStyle sectionTitle = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.2,
  );

  // Premio corrente
  static TextStyle currentPrize = GoogleFonts.poppins(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.gold,
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.5),
        offset: const Offset(2, 2),
        blurRadius: 4,
      ),
    ],
  );

  // Bottoni
  static TextStyle button = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 1,
  );

  // Testo normale
  static TextStyle body = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  // Testo piccolo
  static TextStyle caption = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
  );
}

/// Tema dell'applicazione
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Colori principali
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        secondary: AppColors.amber,
        surface: AppColors.cardBackground,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),

      // Sfondo
      scaffoldBackgroundColor: AppColors.darkBackground,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.appTitle,
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Bottoni elevati
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.amber,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.button,
        ),
      ),

      // Bottoni di testo
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.amber,
          textStyle: AppTextStyles.body,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        contentTextStyle: AppTextStyles.body,
      ),

      // Icone
      iconTheme: const IconThemeData(color: AppColors.amber, size: 24),

      // Tooltip
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: AppTextStyles.caption.copyWith(color: AppColors.textPrimary),
      ),

      // Testo
      textTheme: TextTheme(
        displayLarge: AppTextStyles.numberGiant,
        displayMedium: AppTextStyles.currentPrize,
        displaySmall: AppTextStyles.numberLarge,
        headlineLarge: AppTextStyles.appTitle,
        headlineMedium: AppTextStyles.sectionTitle,
        bodyLarge: AppTextStyles.body,
        bodyMedium: AppTextStyles.body,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}
