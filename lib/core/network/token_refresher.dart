import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/features/auth/data/model/auth_tokens_model/auth_tokens_model.dart';

/// Handles JWT access-token refresh using the stored refresh token.
/// Used by [AuthInterceptor] for transparent 401 retry.
class TokenRefresher {
  TokenRefresher({required FlutterSecureStorage storage}) : _storage = storage;

  final FlutterSecureStorage _storage;

  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await _storage.read(key: StorageKeys.refreshToken);
      if (refreshToken == null || refreshToken.isEmpty) return null;

      final dio = Dio(
        BaseOptions(
          baseUrl: dotenv.get('BASE_URL'),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: const {
            HttpHeadersConst.contentType: HttpHeadersConst.applicationJson,
          },
        ),
      );

      final response = await dio.post(
        EndPoints.refreshToken,
        options: Options(
          headers: {
            HttpHeadersConst.authorization:
                '${HttpHeadersConst.bearerPrefix}$refreshToken',
          },
        ),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) return null;
      final dto = AuthTokensModel.fromJson(data);

      await _storage.write(key: StorageKeys.accessToken, value: dto.accessToken);
      await _storage.write(
        key: StorageKeys.refreshToken,
        value: dto.refreshToken,
      );
      return dto.accessToken;
    } on DioException catch (e, stack) {
      log('Token refresh network error: $e', stackTrace: stack);
      // Let caller handle refresh failures explicitly (e.g. clear session).
      rethrow;
    } catch (e, stack) {
      log('Token refresh unexpected error: $e', stackTrace: stack);
      return null;
    }
  }
}
