import 'package:flutter/material.dart';

import 'app_tokens.dart';

class AppDecorations {
  AppDecorations._();


  static BoxDecoration surfaceCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppTokens.rL),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: AppTokens.shadowAlpha),
          blurRadius: AppTokens.shadowBlurRadius,
          offset: AppTokens.shadowOffset,
        ),
      ],
    );
  }

  static BoxDecoration softBadge({
    required Color color,
    required double radius,
  }) {
    return BoxDecoration(
      color: color.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration accentBar({
    required Color color,
    double radius = AppTokens.rM,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    );
  }
}
