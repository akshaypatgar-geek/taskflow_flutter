import 'package:flutter/material.dart';

import '../theme/app_text_theme.dart';
import '../theme/app_tokens.dart';

/// Full-width primary action button with optional loading state.
/// Uses [AppTokens] and theme [TextTheme] for consistency and dark mode.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
    this.icon,
    this.height,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;
  final Widget? icon;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final labelStyle = context.buttonLabel?.copyWith(
      fontSize: AppTokens.fXl,
      fontWeight: AppTokens.fontWeightBold,
      color: colorScheme.onPrimary,
    ) ??
        TextStyle(
          fontSize: AppTokens.fXl,
          fontWeight: AppTokens.fontWeightBold,
          color: colorScheme.onPrimary,
        );

    final style = ElevatedButton.styleFrom(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.rM),
      ),
      elevation: 2,
    );

    final loadingChild = SizedBox(
      height: 24,
      width: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(colorScheme.onPrimary),
      ),
    );

    final h = height ?? AppTokens.buttonHeight;

    final enabled = !isLoading && onPressed != null;

    final buttonChild = icon != null && !isLoading
        ? ElevatedButton.icon(
            onPressed: onPressed,
            style: style,
            icon: icon!,
            label: Text(label, style: labelStyle),
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: style,
            child: isLoading ? loadingChild : Text(label, style: labelStyle),
          );

    return Semantics(
      button: true,
      label: label,
      tooltip: label,
      enabled: enabled,
      child: SizedBox(
        width: double.infinity,
        height: h,
        child: buttonChild,
      ),
    );
  }
}
