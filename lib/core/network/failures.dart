/// Base Failure (exposed outside repository)
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "Network error occurred"]);
}

/// 404 failure
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = "Resource not found"]);
}

/// 409 failure
class ExistsFailure extends Failure {
  const ExistsFailure([super.message = "Resource already exists"]);
}

/// Generic server failure
class ServerFailure extends Failure {
  const ServerFailure([super.message = "Server error occurred"]);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = "Invalid credentials"]);
}