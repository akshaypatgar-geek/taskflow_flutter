import 'package:flutter/material.dart';

/// Design tokens: single source of truth for spacing, radius, typography,
/// and elevation. Use these (or theme extensions built from them) so the app
/// stays consistent and dark mode can adapt.
class AppTokens {
  AppTokens._();

  // ——— Spacing ———
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 12;
  static const double spacingLg = 16;
  static const double spacingXl = 20;
  static const double spacing2xl = 24;
  static const double spacing3xl = 32;

  // ——— Border radius ———
  static const double radiusSm = 6;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;

  // ——— Typography (font sizes) ———
  static const double fontSizeXs = 11;
  static const double fontSizeSm = 12;
  static const double fontSizeMd = 14;
  static const double fontSizeLg = 16;
  static const double fontSizeXl = 18;
  static const double fontSize2xl = 20;
  static const double fontSize3xl = 24;
  static const double fontSizeDisplay = 36;

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
}
