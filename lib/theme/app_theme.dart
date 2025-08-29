import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium Dribbble-Style CalorieTracker Theme
/// Implements modern, smooth, animated UI with pastel tones and soft gradients
class AppTheme {
  AppTheme._();

  // Premium Pastel Color Palette - Dribbble Style
  static const Color softGreen = Color(0xFFE8F5E8); // Light green
  static const Color softPurple = Color(0xFFF3E8FF); // Light purple
  static const Color softBlue = Color(0xFFE8F4FD); // Soft blue
  static const Color softPeach = Color(0xFFFFF4E6); // Soft peach
  static const Color softRose = Color(0xFFFFF0F5); // Soft rose
  static const Color softYellow = Color(0xFFFFFBE6); // Soft yellow

  // Primary gradient colors for modern look
  static const Color primaryGreen = Color(0xFF4CAF50); // Main green
  static const Color primaryGreenDark = Color(0xFF388E3C); // Dark green
  static const Color accentPurple = Color(0xFF9C27B0); // Accent purple
  static const Color accentBlue = Color(0xFF2196F3); // Accent blue

  // Modern neutral colors
  static const Color backgroundLight =
      Color(0xFFFBFBFB); // Off-white background
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white surface
  static const Color cardLight = Color(0xFFFFFFFF); // Card background

  // Text colors with proper contrast
  static const Color textPrimary = Color(0xFF1A1A1A); // Primary text
  static const Color textSecondary = Color(0xFF757575); // Secondary text
  static const Color textDisabled = Color(0xFFBDBDBD); // Disabled text

  // Dark theme colors
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB3B3B3);

  // Gradient definitions for premium look
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, primaryGreenDark],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9C27B0), Color(0xFF673AB7)],
  );

  static const LinearGradient blueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
  );

  // Card gradients for calorie progress rings
  static const LinearGradient calorieRingGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
  );

  static const LinearGradient macroProteinGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
  );

  static const LinearGradient macroCarbGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)],
  );

  static const LinearGradient macroFatGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
  );

  /// Light theme with premium animations support
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryGreen,
      onPrimary: Colors.white,
      primaryContainer: softGreen,
      onPrimaryContainer: primaryGreenDark,
      secondary: accentBlue,
      onSecondary: Colors.white,
      secondaryContainer: softBlue,
      onSecondaryContainer: accentBlue,
      tertiary: accentPurple,
      onTertiary: Colors.white,
      tertiaryContainer: softPurple,
      onTertiaryContainer: accentPurple,
      surface: surfaceLight,
      onSurface: textPrimary,
      onSurfaceVariant: textSecondary,
      outline: Color(0xFFE0E0E0),
      outlineVariant: Color(0xFFF5F5F5),
    ),

    // Premium typography using Inter font
    textTheme: TextTheme(
      // Large display numbers for calorie counts - Dribbble style
      displayLarge: GoogleFonts.inter(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -1.0,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.5,
        height: 1.15,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.2,
      ),

      // Headings for section titles
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.15,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // Titles for cards and components
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.1,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: -0.1,
      ),

      // Body text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.4,
      ),

      // Labels and small text
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textDisabled,
        letterSpacing: 0.5,
      ),
    ),

    // Premium card theme with rounded corners and soft shadows
    cardTheme: CardThemeData(
      color: cardLight,
      elevation: 0,
      shadowColor: Colors.black.withAlpha(13),
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20), // More rounded for premium look
      ),
      margin: EdgeInsets.zero,
    ),

    // App bar theme - clean and minimal
    appBarTheme: AppBarTheme(
      backgroundColor: backgroundLight,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
      iconTheme: IconThemeData(color: textPrimary, size: 24),
      actionsIconTheme: IconThemeData(color: textPrimary, size: 24),
    ),

    // Premium elevated button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Outlined button theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryGreen,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        side: BorderSide(color: primaryGreen, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryGreen,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    // Premium input decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryGreen, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabled,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Floating action button theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryGreen,
      unselectedItemColor: textSecondary,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    // Progress indicator theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: primaryGreen,
      linearTrackColor: softGreen,
      circularTrackColor: softGreen,
    ),
  );

  /// Dark theme with premium animations support
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF81C784),
      onPrimary: Colors.black,
      primaryContainer: Color(0xFF2E5233),
      onPrimaryContainer: Color(0xFF81C784),
      secondary: Color(0xFF64B5F6),
      onSecondary: Colors.black,
      secondaryContainer: Color(0xFF1565C0),
      onSecondaryContainer: Color(0xFF64B5F6),
      tertiary: Color(0xFFBA68C8),
      onTertiary: Colors.black,
      tertiaryContainer: Color(0xFF7B1FA2),
      onTertiaryContainer: Color(0xFFBA68C8),
      surface: surfaceDark,
      onSurface: textPrimaryDark,
      onSurfaceVariant: textSecondaryDark,
      outline: Color(0xFF424242),
      outlineVariant: Color(0xFF2C2C2C),
    ),

    // Dark theme typography
    textTheme: TextTheme(
      displayLarge: GoogleFonts.inter(
        fontSize: 56,
        fontWeight: FontWeight.w800,
        color: textPrimaryDark,
        letterSpacing: -1.0,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w700,
        color: textPrimaryDark,
        letterSpacing: -0.5,
        height: 1.15,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: textPrimaryDark,
        letterSpacing: -0.25,
        height: 1.2,
      ),
      headlineLarge: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimaryDark,
        letterSpacing: -0.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: -0.15,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      titleLarge: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: -0.15,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: -0.1,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
        letterSpacing: -0.1,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryDark,
        height: 1.4,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondaryDark,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimaryDark,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondaryDark,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Color(0xFF9E9E9E),
        letterSpacing: 0.5,
      ),
    ),

    cardTheme: CardThemeData(
      color: cardDark,
      elevation: 0,
      shadowColor: Colors.black.withAlpha(77),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.zero,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: backgroundDark,
      foregroundColor: textPrimaryDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textPrimaryDark,
      ),
      iconTheme: IconThemeData(color: textPrimaryDark, size: 24),
      actionsIconTheme: IconThemeData(color: textPrimaryDark, size: 24),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF81C784),
        foregroundColor: Colors.black,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF81C784),
      foregroundColor: Colors.black,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceDark,
      selectedItemColor: Color(0xFF81C784),
      unselectedItemColor: textSecondaryDark,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  // Premium pastel color helpers for components
  static List<Color> get pastelColors => [
        softGreen,
        softPurple,
        softBlue,
        softPeach,
        softRose,
        softYellow,
      ];

  static Color getPastelColor(int index) {
    return pastelColors[index % pastelColors.length];
  }

  // Gradient helpers for animated components
  static List<LinearGradient> get premiumGradients => [
        primaryGradient,
        purpleGradient,
        blueGradient,
        calorieRingGradient,
      ];

  static LinearGradient getPremiumGradient(int index) {
    return premiumGradients[index % premiumGradients.length];
  }
}
