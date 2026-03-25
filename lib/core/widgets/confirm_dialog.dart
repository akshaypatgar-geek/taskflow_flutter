import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_tokens.dart';

/// Standard confirm/cancel dialog. Uses [AppTokens] and theme for dark mode. Use for delete, logout, and other confirmations.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    required this.onConfirm,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final bool isDestructive;
  final VoidCallback onConfirm;

  /// Shows the dialog and returns true if user confirmed, false otherwise.
  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool isDestructive = false,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        isDestructive: isDestructive,
        onConfirm: () => ctx.pop(true),
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AlertDialog(
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTokens.rL),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: AppTokens.fontWeightBold,
          color: colorScheme.onSurface,
        ),
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppTokens.sXxl,
        0,
        AppTokens.sXxl,
        AppTokens.sXxl,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => context.pop(false),
                style: ButtonStyle(
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  splashFactory: NoSplash.splashFactory,
                ),
                child: Semantics(
                  button: true,
                  label: cancelLabel,
                  tooltip: cancelLabel,
                  child: Text(cancelLabel),
                ),
              ),
            ),
            const SizedBox(width: AppTokens.sM),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  onConfirm();
                  context.pop(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDestructive ? colorScheme.error : colorScheme.primary,
                  foregroundColor:
                      isDestructive ? colorScheme.onError : colorScheme.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTokens.rM),
                  ),
                  elevation: 2,
                ),
                child: Semantics(
                  button: true,
                  label: confirmLabel,
                  tooltip: confirmLabel,
                  child: Text(
                    confirmLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: AppTokens.fontWeightBold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
