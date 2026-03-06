/// Base Exception (internal use only)
abstract class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

/// Network-related errors (timeouts, no internet, etc.)
class NetworkException extends AppException {
  const NetworkException([super.message = "Network error occurred"]);
}

/// 404
class NotFoundException extends AppException {
  const NotFoundException([super.message = "Resource not found"]);
}

/// 409
class ExistsException extends AppException {
  const ExistsException([super.message = "Resource already exists"]);
}

/// 400 / validation / generic server error
class ServerException extends AppException {
  const ServerException([super.message = "Server error occurred"]);
}

class UnauthorizedException extends AppException {
  UnauthorizedException([super.message="Invalid credentials"]);

}