import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors
  static const Color primaryColor = Color(0xFF1E56A0);
  static const Color primaryDarkColor = Color(0xFF163172);
  static const Color primaryLightColor = Color(0xFF4D7CC7);
  
  // Secondary Colors
  static const Color secondaryColor = Color(0xFFF6D55C);
  static const Color secondaryDarkColor = Color(0xFFD4B53F);
  static const Color secondaryLightColor = Color(0xFFFAE28A);
  
  // Alert Colors
  static const Color dangerColor = Color(0xFFD62839);
  static const Color warningColor = Color(0xFFFF9800);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color infoColor = Color(0xFF2196F3);
  
  // Neutral Colors
  static const Color backgroundColor = Color(0xFFF5F7FA);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  static const Color dividerColor = Color(0xFFE0E0E0);
  
  // Text Colors
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textTertiaryColor = Color(0xFFBDBDBD);
  static const Color textOnPrimaryColor = Colors.white;
  static const Color textOnSecondaryColor = Color(0xFF212121);
  
  // SOS Button Colors
  static const Color sosButtonColor = Color(0xFFD62839);
  static const Color sosButtonPressedColor = Color(0xFFB71C1C);
  static const Color sosCountdownColor = Color(0xFFFF5252);
  
  // Accessibility Colors
  static const Color highContrastBackground = Colors.black;
  static const Color highContrastText = Colors.white;
  static const Color highContrastAccent = Color(0xFFFFF176);
  
  // Get ThemeData for the app
  static ThemeData getTheme(bool isDarkMode, bool isHighContrast) {
    if (isDarkMode) {
      return isHighContrast ? _highContrastDarkTheme : _darkTheme;
    } else {
      return isHighContrast ? _highContrastLightTheme : _lightTheme;
    }
  }
  
  // Light Theme
  static final ThemeData _lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: dangerColor,
      background: backgroundColor,
      surface: surfaceColor,
    ),
    scaffoldBackgroundColor: backgroundColor,
    cardColor: cardColor,
    dividerColor: dividerColor,
    textTheme: _getTextTheme(textPrimaryColor),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: textOnPrimaryColor,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: textOnPrimaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dangerColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
  
  // Dark Theme
  static final ThemeData _darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    colorScheme: ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      error: dangerColor,
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: const Color(0xFF1E1E1E),
    dividerColor: const Color(0xFF424242),
    textTheme: _getTextTheme(Colors.white),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textOnPrimaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryLightColor,
        side: const BorderSide(color: primaryLightColor, width: 1.5),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryLightColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: textOnPrimaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF424242)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryLightColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: dangerColor, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
  );
  
  // High Contrast Light Theme
  static final ThemeData _highContrastLightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.black,
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      secondary: highContrastAccent,
      error: Colors.red,
      background: Colors.white,
      surface: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.white,
    dividerColor: Colors.black,
    textTheme: _getTextTheme(Colors.black, fontWeight: FontWeight.bold),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        side: const BorderSide(color: Colors.black, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.black, width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.black, width: 2),
      ),
    ),
  );
  
  // High Contrast Dark Theme
  static final ThemeData _highContrastDarkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.white,
    colorScheme: const ColorScheme.dark(
      primary: Colors.white,
      secondary: highContrastAccent,
      error: Colors.red,
      background: Colors.black,
      surface: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.black,
    dividerColor: Colors.white,
    textTheme: _getTextTheme(Colors.white, fontWeight: FontWeight.bold),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 2),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1A1A1A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: highContrastAccent, width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    cardTheme: CardTheme(
      color: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
    ),
  );
  
  // Text Theme
  static TextTheme _getTextTheme(Color textColor, {FontWeight fontWeight = FontWeight.normal}) {
    return TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: fontWeight,
          color: textColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: fontWeight,
          color: textColor,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: fontWeight,
          color: textColor,
        ),
    );
  }
}

// App Dimensions
class AppDimensions {
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 48.0;
  
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
  
  static const double buttonHeightS = 36.0;
  static const double buttonHeightM = 48.0;
  static const double buttonHeightL = 56.0;
  
  static const double appBarHeight = 56.0;
  static const double bottomNavBarHeight = 64.0;
  
  static const double sosButtonSize = 80.0;
  static const double sosButtonSizeLarge = 96.0;
}

// Animation Durations
class AppDurations {
  static const Duration fastest = Duration(milliseconds: 150);
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration medium = Duration(milliseconds: 350);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration slower = Duration(milliseconds: 750);
  static const Duration slowest = Duration(milliseconds: 1000);
  
  static const Duration sosCountdown = Duration(seconds: 5);
}
