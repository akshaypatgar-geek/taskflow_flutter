import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/features/auth/data/model/create_user_response/create_user_response.dart';

import '../../../../core/network/end_points.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failures.dart';
import '../../../session_manager/session_manager.dart';
import '../model/refresh_token_response/refresh_token_response.dart';

class AuthRepository {
  final DioClient client;
  final SessionManager sessionManager;


  static late final AuthRepository _instance;

  // Factory constructor returns the singleton
  factory AuthRepository({required DioClient client, required SessionManager sessionManager}) {
    _instance = AuthRepository._internal(client, sessionManager);
    return _instance;
  }

  // Internal private constructor
  AuthRepository._internal(this.client, this.sessionManager);


  Future<Either<Failure,RefreshTokenResponse >> login({required String email, required String password}) async {
    try {
      log("illi?");
      final response = await client.postRequest(endpoint: EndPoints.login,
      body: {
        "email":email,
        "password":password
      });
      log("response :$response");
      final loginDTO = RefreshTokenResponse.fromJson(response);
      await sessionManager.saveAccessToken(loginDTO.accessToken);
    // You could add a saveRefreshToken if SessionManager supports it
    await sessionManager.storage.write(
        key: "refresh_token", value: loginDTO.refreshToken);
      return Right(loginDTO);
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
    // catch(e) {
    //   log("in catch bloc :${e.toString()}");
    //   return Left(ServerFailure(e.toString()));
    // }
  }

  Future<Either<Failure, CreateUserResponse>> signUp({required String email, required String password}) async {
    try {
      final response = await client.postRequest(endpoint: EndPoints.signUp,
      body: {
        "email":email,
        "password":password
      });
      final signUpDTO = CreateUserResponse.fromJson(response);
      return Right(signUpDTO);
    } on NetworkException catch(e) {
      log("got network exception");
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch(e) {
      log("got notfound exception");
      return Left(NotFoundFailure(e.message));
    } on ExistsException catch(e) {
      log("got exists exception");
      return Left(ExistsFailure(e.message));
    }on UnauthorizedException catch(e) {
      return Left(UnauthorizedFailure(e.message));
    }on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<String?> refreshToken() async{
  //   try {
  //   final refreshToken = await storage.read(key: 'refresh_token');
  //   if(refreshToken == null) {
  //     return null;
  //   }
  //   final options = Options(extra: {"skipAuthInterceptor": true},
  //   headers: {
  //     "Authorization": 'Bearer $refreshToken',
  //     'Content-Type': 'application/json'
  //   },
    
  //   );
  //    var response =await client.postRequest(endpoint: EndPoints.refreshToken,
  //    options: options,
  //    );
  //    log("response :${response.data}");
  //   final responDTO  = RefreshTokenResponse.fromJson(response.data);
  //   await storage.write(key:"access_token",value: responDTO.accessToken);
  //   await storage.write(key:"refresh_token",value: responDTO.refreshToken);
  //   return responDTO.accessToken;
  //   } catch (e) {
  //     log("refresh token error repo: $e");
  //   }
  //   return null;
  // }
  try {
  final refreshToken = await sessionManager.storage.read(key: 'refresh_token');
    if (refreshToken == null) return null;

    final options = Options(
      extra: {"skipAuthInterceptor": true},
      headers: {
        "Authorization": 'Bearer $refreshToken',
        "Content-Type": "application/json",
      },
    );

    var response = await client.postRequest(
      endpoint: EndPoints.refreshToken,
      options: options,
      body: {}
    );

    final responDTO = RefreshTokenResponse.fromJson(response);

    // Save tokens in SessionManager
    await sessionManager.saveAccessToken(responDTO.accessToken);
    await sessionManager.storage.write(
        key: "refresh_token", value: responDTO.refreshToken);

    return responDTO.accessToken;
  } catch (e) {
    log("refresh token error repo: $e");
  }
  return null;
  }
}