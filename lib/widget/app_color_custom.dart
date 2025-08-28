import 'package:flutter/material.dart';

class AppColor {
  static const Color primaryBlue = Color(0xFF4761C9);      
  static const Color mediumBlue = Color(0xFF749BC2);       
  static const Color lightBlue = Color(0xFF91C8E4);        
  static const Color lightCream = Color(0xFFFFFBDE);       

  
  static const Color errorDark = Color(0xFF8B0000);        
  static const Color errorLight = Color(0xFFFF6347);       

  
  static const Color successDark = Color(0xFF006400);      
  static const Color successLight = Color(0xFF90EE90);     

  
  static const Color surface = Colors.white;
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onAccent = Colors.black87;
  static const Color onBackground = Colors.black87;
  static const Color onSurface = Colors.black87;

  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, mediumBlue],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightBlue, lightCream],
  );

  
  static ColorScheme get colorScheme => ColorScheme.light(
    primary: primaryBlue,
    secondary: mediumBlue,
    surface: surface,
    background: lightCream,
    onPrimary: onPrimary,
    onSecondary: onSecondary,
    onSurface: onSurface,
    onBackground: onBackground,
  );

  
  static MaterialColor get primarySwatch {
    return MaterialColor(
      primaryBlue.value,
      <int, Color>{
        50: lightCream,
        100: lightBlue,
        200: mediumBlue.withOpacity(0.3),
        300: mediumBlue.withOpacity(0.5),
        400: mediumBlue.withOpacity(0.7),
        500: primaryBlue,
        600: primaryBlue.withOpacity(0.8),
        700: primaryBlue.withOpacity(0.6),
        800: primaryBlue.withOpacity(0.4),
        900: primaryBlue.withOpacity(0.2),
      },
    );
  }
}
