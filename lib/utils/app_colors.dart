import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primaryOrange = Color(0xFFEE6402);
  static const Color warmCream = Color(0xFFFDECB3);
  static const Color darkBrown = Color(0xFF531901);
  static const Color richBrownBlack = Color(0xFF2E1B0B);
  
  // Glassmorphism colors
  static Color glassWhite = Colors.white.withOpacity(0.15);
  static Color glassBorder = Colors.white.withOpacity(0.25);
  
  // Gradient colors
  static const List<Color> backgroundGradient = [
    warmCream,
    Color(0xFFFFD89B),
  ];
  
  static const List<Color> orangeGradient = [
    primaryOrange,
    Color(0xFFFF8534),
  ];
}
