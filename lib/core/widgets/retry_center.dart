import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';
import '../utils/constants.dart';

/// Generic centered retry UI for bloc error/empty states.
class RetryCenter extends StatelessWidget {
  const RetryCenter({
    super.key,
    required this.message,
    required this.onRetry,
    this.buttonLabel = AppStrings.retry,
  });

  final String message;
  final VoidCallback onRetry;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTokens.sL),
          Semantics(
            button: true,
            label: buttonLabel,
            tooltip: buttonLabel,
            child: OutlinedButton(
              onPressed: onRetry,
              child: Text(buttonLabel),
            ),
          ),
        ],
      ),
    );
  }
}

