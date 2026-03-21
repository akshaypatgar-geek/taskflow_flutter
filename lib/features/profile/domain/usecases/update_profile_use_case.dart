import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/profile/domain/entities/user_details/user_details.dart';
import 'package:taskflowapp/features/profile/domain/repository/profile_repository_interface.dart';

/// Use case: Update user profile (name, profile picture).
/// Caches the result on success.
class UpdateProfileUseCase {
  UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<Failure, UserDetails>> call({
    String? name,
    String? profilePicture,
  }) {
    return _repository.updateUserDetails(
      name: name,
      profilePicture: profilePicture,
    );
  }
}
