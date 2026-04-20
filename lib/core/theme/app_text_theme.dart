import 'package:flutter/material.dart';

extension AppTextThemeX on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;

  TextStyle? get screenTitle => textTheme.headlineMedium;
  TextStyle? get sectionTitle => textTheme.titleLarge;
  TextStyle? get body => textTheme.bodyMedium;
  TextStyle? get caption => textTheme.bodySmall;
  TextStyle? get buttonLabel => textTheme.labelLarge;
}
