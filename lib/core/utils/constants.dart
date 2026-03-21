/// Centralized error and success messages.
abstract final class AppStrings {
  AppStrings._();

  // --- Validation errors ---
  static const String emailRequired = 'Email required';
  static const String invalidEmailFormat = 'Invalid email format';
  static const String passwordRequired = 'Password cannot be empty';
  static const String passwordTooShort = 'Password too short';
  static const String titleRequired = 'Title required';
  static const String titleCannotBeEmpty = 'Title can not be empty';

  // --- Success messages ---
  static const String taskDeleted = 'Task deleted';
  static const String taskDetailsUpdated = 'Task details updated';

  static String taskCreated(String taskTitle) => 'Task $taskTitle created';

  // --- Error messages ---
  static const String connectionError = 'Connection error. Please try again.';
  static const String networkErrorOccurred = 'Network error occurred';
  static const String somethingWentWrong = 'Something went wrong.';
  static const String serverErrorOccurred = 'Server error occurred';
  static const String somethingWrongTryAgainLater =
      'Something wrong. Please try again later.';
  static const String resourceNotFound = 'Resource not found';
  static const String resourceAlreadyExists = 'Resource already exists';
  static const String invalidCredentials = 'Invalid credentials';

  // --- Legacy ---
  static const String userNotFound = 'User Not Found';
}
