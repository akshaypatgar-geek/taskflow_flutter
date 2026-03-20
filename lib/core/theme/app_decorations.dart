import 'package:flutter/material.dart';

import 'app_tokens.dart';

class AppDecorations {
  AppDecorations._();


  static BoxDecoration surfaceCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BoxDecoration(
      color: colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(AppTokens.radiusLg),
      boxShadow: [
        BoxShadow(
          color: colorScheme.shadow.withValues(alpha: AppTokens.shadowAlpha),
          blurRadius: AppTokens.shadowBlurRadius,
          offset: AppTokens.shadowOffset,
        ),
      ],
    );
  }
}
