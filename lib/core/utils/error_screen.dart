import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taskflowapp/core/routes/router.dart';
import 'package:taskflowapp/core/widgets/primary_button.dart';
import 'package:taskflowapp/core/widgets/network_aware_app_bar.dart';
import 'package:taskflowapp/core/theme/app_tokens.dart';
import 'package:taskflowapp/core/utils/constants.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: const NetworkAwareAppBar(
        title: Text(AppStrings.pageNotFound),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppTokens.fullPageErrorIconSize,
              color: colorScheme.outline,
            ),
            const SizedBox(height: AppTokens.sXl),
            Text(
              AppStrings.notFoundCode,
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTokens.sM),
            Text(
              AppStrings.pageNotFoundMessage,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppTokens.sXxxl),
            Semantics(
              label: AppStrings.goHome,
              child: PrimaryButton(
                label: AppStrings.goHome,
                onPressed: () => context.go(ScreenPaths.root.path),
              ),
            ),
          ],
        ),
      ),
    );
  }
}