import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/features/auth/data/model/auth_tokens_model/auth_tokens_model.dart';

class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage storage;
  final Dio dio;

  AuthInterceptor({required this.storage, required this.dio});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
    if (options.extra["skipAuthInterceptor"] == true) {
      return handler.next(options);
    }
    final token = await storage.read(key: 'access_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.extra["skipAuthInterceptor"] == true) {
      return super.onError(err, handler);
    }


    if (err.response?.statusCode == 401 && err.requestOptions.extra["retried"] != true) {
      err.requestOptions.extra['retried'] = true;

      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e, stack) {
        log('Refresh token failed: $e\n$stack');
      }
    }

    super.onError(err, handler);
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await storage.read(key: 'refresh_token');
      if (refreshToken == null) return null;

      final options = Options(
        headers: {
          'Authorization': 'Bearer $refreshToken',
          'Content-Type': 'application/json',
        },
        extra: {'skipAuthInterceptor': true},
      );

      final response = await dio.post(EndPoints.refreshToken, options: options);
      final dto = AuthTokensModel.fromJson(response.data);

      await storage.write(key: 'access_token', value: dto.accessToken);
      await storage.write(key: 'refresh_token', value: dto.refreshToken);

      return dto.accessToken;
    } catch (e, stack) {
      log('Error refreshing token: $e\n$stack');
      return null;
    }
  }
}