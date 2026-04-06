import 'package:dartz/dartz.dart';
import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/core/network/exception_to_failure.dart';
import 'package:taskflowapp/core/network/exceptions.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/core/network/token_refresher.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/features/auth/data/model/auth_tokens_model/auth_tokens_model.dart';
import 'package:taskflowapp/features/auth/data/model/auth_user_model/auth_user_model.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_tokens/auth_tokens.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_user/auth_user.dart';
import 'package:taskflowapp/features/auth/domain/repository/auth_repository_interface.dart';
import 'package:taskflowapp/features/profile/data/datasources/local/model/user_details_hive.dart';
import 'package:taskflowapp/features/tasks/local/model/task_hive/task_hive.dart';

import '../../../../core/session_manager/session_manager.dart';

/// Concrete auth repository backed by [DioClient] for network calls,
/// [SessionManager] for token persistence, and [TokenRefresher] for silent renewal.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.client,
    required this.sessionManager,
    required this.tokenRefresher,
  });

  final DioClient client;
  final SessionManager sessionManager;
  final TokenRefresher tokenRefresher;

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
      if (response == null) {
        throw const ServerException(AppStrings.somethingWrongTryAgainLater);
      }

      final loginDTO = AuthTokensModel.fromJson(response);
      await sessionManager.saveAccessToken(loginDTO.accessToken);
      await sessionManager.storage.write(
        key: StorageKeys.refreshToken,
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
      if (response == null) {
        throw const ServerException(AppStrings.somethingWrongTryAgainLater);
      }

      final signUpDTO = AuthUserModel.fromJson(response);
      return Right(AuthUser(email: signUpDTO.userEmail, userId: signUpDTO.userId));
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    }
  }

  @override
  Future<String?> refreshToken() async {
    return tokenRefresher.refreshAccessToken();
  }

  @override
  Future<void> logout() async {
    await sessionManager.clearSession();
    await Hive.box<TaskHive>('tasks').clear();
    await Hive.box<UserDetailsHive>('userBox').clear();
  }
}
