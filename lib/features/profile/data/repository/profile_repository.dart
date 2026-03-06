import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/features/profile/data/model/user_details/user_details.dart';

import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failures.dart';

class ProfileRepository {
  final DioClient client;

  ProfileRepository({required this.client});

  Future<Either<Failure, UserDetails>> getUserDetails() async {
    try {
      final response = await client.getRequest(endpoint: EndPoints.getUserDetails);
      log("response :$response");
      final responseDTO = UserDetails.fromJson(response);
      return Right(responseDTO);
    }on NetworkException catch(e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch(e) {
      return Left(NotFoundFailure(e.message));
    } on ExistsException catch(e) {
      return Left(ExistsFailure(e.message));
    } on UnauthorizedException catch(e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<Either<Failure, UserDetails>> updateUserDetails({
    String? name, String? profilePicture
  }) async {
    try {
      final response = await client.patchRequest(endpoint: EndPoints.updateUser,
      body: {
        "name":name,
        "profilePicture":profilePicture
      });
      
      final responseDto = UserDetails.fromJson(response);
      return Right(responseDto);
    } on NetworkException catch(e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch(e) {
      return Left(NotFoundFailure(e.message));
    } on ExistsException catch(e) {
      return Left(ExistsFailure(e.message));
    } on UnauthorizedException catch(e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    }
  }
}