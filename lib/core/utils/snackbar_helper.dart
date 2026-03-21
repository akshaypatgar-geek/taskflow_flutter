import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class SnackbarHelper {
  static void showSuccessMessage({
    required BuildContext context,
    required String message,
  }) {
    final backgroundColor = AppStatusColors.of(context).done;
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showErrorMessage({
    required BuildContext context,
    required String message,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: colorScheme.error,
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}