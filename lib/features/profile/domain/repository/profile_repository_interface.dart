import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/profile/domain/entities/user_details/user_details.dart';


abstract interface class ProfileRepository {
 
  Future<Either<Failure, UserDetails>> getUserDetails();

  Future<Either<Failure, UserDetails>> updateUserDetails({
    String? name,
    String? profilePicture,
  });
}
