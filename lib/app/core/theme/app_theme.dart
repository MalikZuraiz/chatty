import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Premium Dark Color Palette - Dark purples, deep blacks, neon accents
  static const Color primaryDark = Color(0xFF0F0B1F);         // Deep black-purple
  static const Color surfaceDark = Color(0xFF161234);         // Dark purple surface
  static const Color cardDark = Color(0xFF1E1A35);            // Card dark purple
  static const Color backgroundDark = Color(0xFF0A0712);      // Deepest background
  
  // Neon Accent Colors for Premium Feel
  static const Color neonBlue = Color(0xFF00D4FF);           // Electric blue
  static const Color neonPink = Color(0xFFFF006E);           // Hot pink
  static const Color neonPurple = Color(0xFF8B5CF6);         // Vibrant purple
  static const Color neonCyan = Color(0xFF06FFA5);           // Mint green
  static const Color neonYellow = Color(0xFFFFBE0B);         // Electric yellow
  
  // Glass Colors for Glassmorphism Effect
  static const Color glassWhite = Color(0x1AFFFFFF);         // White glass overlay
  static const Color glassBlack = Color(0x0D000000);         // Black glass overlay
  static const Color glassBorder = Color(0x33FFFFFF);        // Glass border
  static const Color glassHighlight = Color(0x66FFFFFF);     // Glass highlight
  
  // Text Colors for Premium Feel
  static const Color textPrimary = Color(0xFFFFFFFF);        // Pure white
  static const Color textSecondary = Color(0xB3FFFFFF);      // 70% white
  static const Color textTertiary = Color(0x80FFFFFF);       // 50% white
  static const Color textDisabled = Color(0x4DFFFFFF);       // 30% white
  
  // Status Colors
  static const Color successColor = Color(0xFF00FF88);        // Success green
  static const Color warningColor = Color(0xFFFFBE0B);        // Warning yellow
  static const Color errorColor = Color(0xFFFF0040);          // Error red
  static const Color infoColor = Color(0xFF00D4FF);           // Info blue
  
  // Legacy Aliases for Compatibility
  static const Color chattyPrimary = neonPurple;              // Primary color
  static const Color chattySecondary = neonBlue;              // Secondary color
  static const Color chattyAccent = neonPink;                 // Accent color
  static const Color chattyDark = backgroundDark;             // Background
  static const Color chattySurface = surfaceDark;             // Surface color
  static const Color chattyCard = cardDark;                   // Card color
  static const Color chattyText = textPrimary;                // Text color
  static const Color chattySubtext = textSecondary;           // Subtext color
  static const Color chattyBorder = glassBorder;              // Border color
  
  // Premium Gradients for Glassmorphism
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonPurple, neonBlue],
    stops: [0.0, 1.0],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonBlue, neonCyan],
    stops: [0.0, 1.0],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, backgroundDark],
    stops: [0.0, 1.0],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [neonPink, neonYellow],
    stops: [0.0, 1.0],
  );
  
  static const LinearGradient glassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [glassWhite, glassBlack],
    stops: [0.0, 1.0],
  );
  
  // Legacy Gradient Aliases
  static const LinearGradient chattyPrimaryGradient = primaryGradient;
  static const LinearGradient chattySecondaryGradient = secondaryGradient;
  static const LinearGradient chattyBackgroundGradient = backgroundGradient;
  static const LinearGradient chattyAccentGradient = accentGradient;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.purple,
      primaryColor: chattyPrimary,
      fontFamily: GoogleFonts.poppins().fontFamily,
      scaffoldBackgroundColor: Colors.white,
      textTheme: TextTheme(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: neonPurple,
      fontFamily: GoogleFonts.inter().fontFamily, // Premium typography
      colorScheme: const ColorScheme.dark(
        primary: neonPurple,
        secondary: neonBlue,
        surface: surfaceDark,
        background: backgroundDark,
        error: errorColor,
        onPrimary: textPrimary,
        onSecondary: textPrimary,
        onSurface: textPrimary,
        onBackground: textPrimary,
        onError: textPrimary,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: textPrimary,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
          color: textPrimary,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.1,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textSecondary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.normal,
          color: textTertiary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          color: textPrimary,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: glassBorder, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: textPrimary,
          backgroundColor: neonPurple,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceDark.withAlpha(128),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: glassBorder, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: glassBorder, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: neonBlue, width: 1.5),
        ),
        hintStyle: GoogleFonts.inter(
          color: textTertiary,
          fontSize: 14,
        ),
        labelStyle: GoogleFonts.inter(
          color: textSecondary,
          fontSize: 12,
        ),
        floatingLabelStyle: GoogleFonts.inter(
          color: neonBlue,
          fontSize: 12,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceDark.withAlpha(200),
        selectedItemColor: neonPurple,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}