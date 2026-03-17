import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/features/profile/data/model/user_details/user_details.dart';
import 'package:taskflowapp/features/profile/local/user_profile_local_repository/user_profile_local_repository.dart';

import '../../../../core/network/exception_to_failure.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failures.dart';

class ProfileRepository {
  final DioClient client;
  final UserProfileLocalRepository localRepository;

  ProfileRepository({required this.client, required this.localRepository});

  Future<Either<Failure, UserDetails>> getUserDetails() async {
    try {
      final response = await client.getRequest<Map<String, dynamic>>(endpoint: EndPoints.getUserDetails);
      final responseDTO = UserDetails.fromJson(response!);
      await localRepository.cacheUser(responseDTO);
      return Right(responseDTO);
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    }
  }

  Future<Either<Failure, UserDetails>> updateUserDetails({
    String? name,
    String? profilePicture,
  }) async {
    try {
      final response = await client.patchRequest<Map<String, dynamic>>(
        endpoint: EndPoints.updateUser,
        body: {
          'name': name,
          'profilePicture': profilePicture,
        },
      );
      final responseDto = UserDetails.fromJson(response!);
      await localRepository.cacheUser(responseDto);
      return Right(responseDto);
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    }
  }
}