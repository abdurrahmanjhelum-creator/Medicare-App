import 'package:flutter/material.dart';

class AppColors {
  // Primary Gradient Colors
  static const Color primaryGreen = Color(0xff089B73);
  static const Color secondaryGreen = Color(0xff28C7C0);
  
  // Background Colors
  static const Color scaffoldBackground = Color(0xFFF6F7FB);
  static const Color white = Colors.white;
  
  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  
  // Border and Divider
  static const Color border = Color(0xFFE5E7EB);
  
  // Status Colors
  static const Color error = Colors.red;
  static const Color errorRed = Colors.red;
  static const Color success = Color(0xff089B73);
  static const Color successGreen = Color(0xff089B73);
  static const Color warning = Colors.orange;
  static const Color warningOrange = Colors.orange;
  static const Color primaryBlue = Color(0xFF089B73);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, secondaryGreen],
  );
}
