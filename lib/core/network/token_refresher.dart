import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/features/auth/data/model/auth_tokens_model/auth_tokens_model.dart';

class TokenRefresher {
  TokenRefresher({required FlutterSecureStorage storage}) : _storage = storage;

  final FlutterSecureStorage _storage;

  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null || refreshToken.isEmpty) return null;

      final dio = Dio(
        BaseOptions(
          baseUrl: dotenv.get('BASE_URL'),
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: const {'Content-Type': 'application/json'},
        ),
      );

      final response = await dio.post(
        EndPoints.refreshToken,
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
        ),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) return null;
      final dto = AuthTokensModel.fromJson(data);

      await _storage.write(key: 'access_token', value: dto.accessToken);
      await _storage.write(key: 'refresh_token', value: dto.refreshToken);
      return dto.accessToken;
    } catch (e, stack) {
      log('Token refresh failed: $e\n$stack');
      return null;
    }
  }
}
