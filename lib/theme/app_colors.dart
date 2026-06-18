import 'package:flutter/material.dart';

class AppColors {
  // Deep dark backgrounds
  static const Color bgDeep = Color(0xFF050B18);
  static const Color bgSurface = Color(0xFF0A1628);
  static const Color bgCard = Color(0xFF0F2040);
  static const Color bgCardAlt = Color(0xFF0D1B35);

  // Premium accent colors
  static const Color accentTeal = Color(0xFF64FFDA);
  static const Color accentBlue = Color(0xFF00B4D8);
  static const Color accentPurple = Color(0xFFBD93F9);
  static const Color accentPink = Color(0xFFFF79C6);

  // Text hierarchy
  static const Color textPrimary = Color(0xFFCCD6F6);
  static const Color textSecondary = Color(0xFF8892B0);
  static const Color textMuted = Color(0xFF4A5568);
  static const Color textWhite = Color(0xFFF8FAFC);

  // Borders
  static const Color borderColor = Color(0xFF1E3A5F);
  static const Color borderAccent = Color(0xFF64FFDA);

  // Shadows
  static const Color shadowTeal = Color(0x4064FFDA);
  static const Color shadowPurple = Color(0x40BD93F9);
  static const Color shadowBlue = Color(0x4000B4D8);

  // Gradients
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentTeal, accentBlue, accentPurple],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient tealBlueGradient = LinearGradient(
    colors: [accentTeal, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleBlueGradient = LinearGradient(
    colors: [accentPurple, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF0F2040), Color(0xFF0D1B35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroBg = LinearGradient(
    colors: [Color(0xFF050B18), Color(0xFF0A1628), Color(0xFF060E1E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
