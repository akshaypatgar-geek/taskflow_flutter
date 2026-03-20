import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/profile/domain/entities/user_details/user_details.dart';
import 'package:taskflowapp/features/profile/domain/repository/profile_repository_interface.dart';

/// Use case: Fetch user profile from API.
/// Caches the result on success.
class GetProfileDetailsUseCase {
  GetProfileDetailsUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, UserDetails>> call() {
    return _repository.getUserDetails();
  }
}
