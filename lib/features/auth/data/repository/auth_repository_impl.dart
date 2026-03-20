import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/core/network/exception_to_failure.dart';
import 'package:taskflowapp/core/network/exceptions.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/auth/data/model/auth_tokens_model/auth_tokens_model.dart';
import 'package:taskflowapp/features/auth/data/model/auth_user_model/auth_user_model.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_tokens/auth_tokens.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_user/auth_user.dart';
import 'package:taskflowapp/features/auth/domain/repository/auth_repository_interface.dart';
import 'package:taskflowapp/features/profile/data/datasources/local/model/user_details_hive.dart';
import 'package:taskflowapp/features/session_manager/session_manager.dart';
import 'package:taskflowapp/features/tasks/local/model/task_hive/task_hive.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.client,
    required this.sessionManager,
  });

  final DioClient client;
  final SessionManager sessionManager;

  @override
  Future<bool> hasValidSession() async {
    return sessionManager.hasValidSession();
  }

  @override
  Future<String?> getAccessToken() async {
    return sessionManager.getAccessToken();
  }

  @override
  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.postRequest<Map<String, dynamic>>(
        endpoint: EndPoints.login,
        body: {'email': email, 'password': password},
      );

      final loginDTO = AuthTokensModel.fromJson(response!);
      await sessionManager.saveAccessToken(loginDTO.accessToken);
      await sessionManager.storage.write(
        key: 'refresh_token',
        value: loginDTO.refreshToken,
      );

      return Right(AuthTokens(accessToken: loginDTO.accessToken, refreshToken: loginDTO.refreshToken));
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, AuthUser>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.postRequest<Map<String, dynamic>>(
        endpoint: EndPoints.signUp,
        body: {'email': email, 'password': password},
      );

      final signUpDTO = AuthUserModel.fromJson(response!);
      return Right(AuthUser(email: signUpDTO.userEmail, uaserID: signUpDTO.userId));
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    }
  }

  @override
  Future<String?> refreshToken() async {
    try {
      final refreshToken = await sessionManager.storage.read(key: 'refresh_token');
      if (refreshToken == null) return null;

      final options = Options(
        extra: {'skipAuthInterceptor': true},
        headers: {
          'Authorization': 'Bearer $refreshToken',
          'Content-Type': 'application/json',
        },
      );

      final response = await client.postRequest<Map<String, dynamic>>(
        endpoint: EndPoints.refreshToken,
        options: options,
        body: {},
      );

      final responDTO = AuthTokensModel.fromJson(response!);

      await sessionManager.saveAccessToken(responDTO.accessToken);
      await sessionManager.storage.write(
        key: 'refresh_token',
        value: responDTO.refreshToken,
      );

      return responDTO.accessToken;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    await sessionManager.clearSession();
    await Hive.box<TaskHive>('tasks').clear();
    await Hive.box<UserDetailsHive>('userBox').clear();
  }
}
