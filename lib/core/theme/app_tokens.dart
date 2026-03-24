import 'package:flutter/material.dart';

/// Design tokens: single source of truth for spacing, radius, typography,
/// and elevation. Use these (or theme extensions built from them) so the app
/// stays consistent and dark mode can adapt.
class AppTokens {
  AppTokens._();

  // ——— Spacing ———
  static const double s = 4;
  static const double sM = 8;
  static const double sL = 12;
  static const double sXl = 16;
  static const double sXxl = 20;
  static const double sXxxl = 24;
  static const double s4xl = 32;

  // ——— Border radius ———
  static const double r = 6;
  static const double rM = 12;
  static const double rL = 16;
  static const double rXl = 20;

  // ——— Typography (font sizes) ———
  static const double f = 11;
  static const double fM = 12;
  static const double fL = 14;
  static const double fXl = 16;
  static const double fXxl = 18;
  static const double fXxxl = 20;
  static const double f4xl = 24;
  static const double fDisplay = 36;

  // ——— Font weights ———
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // ——— Elevation / shadow ———
  static const double shadowBlurRadius = 10;
  static const Offset shadowOffset = Offset(0, 5);
  static const double shadowAlpha = 0.05;

  // ——— Component heights ———
  static const double buttonHeight = 50;
  static const double inputMinHeight = 48;

  // ——— Component sizes ———
  static const double avatarRadius = 50;
}
