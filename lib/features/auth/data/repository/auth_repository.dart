import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/features/auth/data/model/create_user_response/create_user_response.dart';
import 'package:taskflowapp/features/profile/local/model/user_details_hive.dart';
import 'package:taskflowapp/features/tasks/local/model/task_hive/task_hive.dart';

import '../../../../core/network/end_points.dart';
import '../../../../core/network/exception_to_failure.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failures.dart';
import '../../../session_manager/session_manager.dart';
import '../model/refresh_token_response/refresh_token_response.dart';

class AuthRepository {
  final DioClient client;
  final SessionManager sessionManager;


  static late final AuthRepository _instance;

  factory AuthRepository({required DioClient client, required SessionManager sessionManager}) {
    _instance = AuthRepository._internal(client, sessionManager);
    return _instance;
  }

  AuthRepository._internal(this.client, this.sessionManager);


  Future<Either<Failure,RefreshTokenResponse >> login({required String email, required String password}) async {
    try {
     
      final response = await client.postRequest<Map<String, dynamic>>(endpoint: EndPoints.login,
      body: {
        "email":email,
        "password":password
      });
      
      final loginDTO = RefreshTokenResponse.fromJson(response!);
      await sessionManager.saveAccessToken(loginDTO.accessToken);
    await sessionManager.storage.write(
        key: "refresh_token", value: loginDTO.refreshToken);
      return Right(loginDTO);
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    }
  }

  Future<Either<Failure, CreateUserResponse>> signUp({required String email, required String password}) async {
    try {
      final response = await client.postRequest<Map<String, dynamic>>(endpoint: EndPoints.signUp,
      body: {
        "email":email,
        "password":password
      });
      final signUpDTO = CreateUserResponse.fromJson(response!);
      return Right(signUpDTO);
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    }
  }

  Future<String?> refreshToken() async{
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

    var response = await client.postRequest<Map<String, dynamic>>(
      endpoint: EndPoints.refreshToken,
      options: options,
      body: {},
    );

    final responDTO = RefreshTokenResponse.fromJson(response!);

    await sessionManager.saveAccessToken(responDTO.accessToken);
    await sessionManager.storage.write(
        key: "refresh_token", value: responDTO.refreshToken);

    return responDTO.accessToken;
  } catch (e) {
    return null;
  }
  
  }

  Future<void> logout() async {
    await sessionManager.clearSession();
    await Hive.box<TaskHive>('tasks').clear();
    await Hive.box<UserDetailsHive>('userBox').clear();
  }
}