import 'package:flutter/material.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';

/// Centered loading indicator. Use across features for loading states.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    const child = Center(child: CircularProgressIndicator());
    if (message == null || message!.isEmpty) {
      return child;
    }
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: AppTokens.sXl),
          Text(
            message!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
