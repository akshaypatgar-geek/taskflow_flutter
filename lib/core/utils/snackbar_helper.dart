import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSuccessMessage({required BuildContext context, required String message}) {
    SnackBar snackBar = SnackBar(content: Text(message),
    backgroundColor: Colors.green,
     clipBehavior: Clip.antiAlias,
     elevation: 4,
     behavior: SnackBarBehavior.floating,
     duration: const Duration(seconds: 2),
     );
    ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
  }

  static void showErrorMessage({required BuildContext context, required String message}) {
    SnackBar snackBar = SnackBar(content: Text(message),
    backgroundColor: Colors.red,
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