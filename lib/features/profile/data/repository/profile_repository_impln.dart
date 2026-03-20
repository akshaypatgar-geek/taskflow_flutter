

import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/exception_to_failure.dart';
import 'package:taskflowapp/core/network/exceptions.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/profile/data/datasources/profile_datasource_interface.dart';
import 'package:taskflowapp/features/profile/data/datasources/profile_datasource_local.dart';
import 'package:taskflowapp/features/profile/domain/entities/user_details/user_details.dart';
import 'package:taskflowapp/features/profile/domain/repository/profile_repository_interface.dart';

class ProfileRepositoryImpln implements ProfileRepository{
  final ProfileDatasourceRemote remoteDataSource;
  final ProfileDatasourceLocal localDataSource;

  ProfileRepositoryImpln({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<Either<Failure, UserDetails>> getUserDetails() async{
    try {
      final userDetailsModel = await remoteDataSource.getUserDetails();
      await localDataSource.updateUserDetails(userModel: userDetailsModel);
     final UserDetails entity = UserDetails(userId: userDetailsModel.userId, userEmail: userDetailsModel.userEmail, userName: userDetailsModel.userName, userStatus: userDetailsModel.userStatus, profilePicture: userDetailsModel.profilePicture);
      return right(entity);
    }on AppException catch (er) {
      try {
         final localData = await localDataSource.getUserDetails();
         final entity = UserDetails(userId: localData.userId, userEmail: localData.userEmail, userName: localData.userName, userStatus: localData.userStatus, profilePicture: localData.profilePicture);
      
         return right(entity);
      }on AppException catch(_){
       return Left(exceptionToFailure(er)) ;
      }
    }
  }

  @override
  Future<Either<Failure, UserDetails>> updateUserDetails({String? name, String? profilePicture}) async{
    try {
      final response = await remoteDataSource.updateUserDetails(name: name, profilePicture: profilePicture);
      final entity = UserDetails(userId: response.userId, userEmail: response.userEmail, userName: response.userName, userStatus: response.userStatus, profilePicture: response.profilePicture);
      
      return right(entity);
    } on AppException catch(e) {
      return left(exceptionToFailure(e));
    }
  }

}