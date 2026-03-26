import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'network/token_refresher.dart';

class AuthInterceptor extends QueuedInterceptor {
  final FlutterSecureStorage storage;
  final Dio dio;
  final TokenRefresher tokenRefresher;

  AuthInterceptor({
    required this.storage,
    required this.dio,
    required this.tokenRefresher,
  });

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
        final newToken = await tokenRefresher.refreshAccessToken();
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
        await storage.delete(key: 'access_token');
        await storage.delete(key: 'refresh_token');
        log('Session expired: refresh token unavailable/invalid.');
      } catch (e, stack) {
        log('Refresh token failed: $e\n$stack');
        await storage.delete(key: 'access_token');
        await storage.delete(key: 'refresh_token');
      }
    }

    super.onError(err, handler);
  }
}