import 'package:taskflowapp/core/utils/constants.dart';

/// Base Exception (internal use only)
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

/// Network-related errors (timeouts, no internet, etc.)
class NetworkException extends AppException {
  const NetworkException([super.message = AppStrings.connectionError]);
}

/// 404
class NotFoundException extends AppException {
  const NotFoundException([super.message = AppStrings.resourceNotFound]);
}

/// 409
class ExistsException extends AppException {
  const ExistsException([super.message = AppStrings.resourceAlreadyExists]);
}

/// 400 / validation / generic server error
class ServerException extends AppException {
  const ServerException([super.message = AppStrings.somethingWentWrong]);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message = AppStrings.invalidCredentials]);

}