import 'exceptions.dart';
import 'failures.dart';

/// Maps any [AppException] to the corresponding [Failure].
Failure exceptionToFailure(AppException e) {
  return switch (e) {
    NetworkException() => NetworkFailure(e.message),
    NotFoundException() => NotFoundFailure(e.message),
    ExistsException() => ExistsFailure(e.message),
    UnauthorizedException() => UnauthorizedFailure(e.message),
    ServerException() => ServerFailure(e.message),
    _ => ServerFailure(e.message),
  };
}
