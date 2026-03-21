import 'package:taskflowapp/core/utils/constants.dart';

/// Base Failure (exposed outside repository)
abstract class Failure {
  final String message;
  /// True when the error is retryable (e.g. network offline). Use cached data if available.
  final bool isRetryable;
  const Failure(this.message, {this.isRetryable = false});
}

/// Network failure (offline, timeout, etc.). Retryable - prefer cached data when available.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = AppStrings.networkErrorOccurred])
      : super(isRetryable: true);
}

/// 404 failure
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = AppStrings.resourceNotFound]);
}

/// 409 failure
class ExistsFailure extends Failure {
  const ExistsFailure([super.message = AppStrings.resourceAlreadyExists]);
}

/// Generic server failure
class ServerFailure extends Failure {
  const ServerFailure([super.message = AppStrings.serverErrorOccurred]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = AppStrings.invalidCredentials]);
}