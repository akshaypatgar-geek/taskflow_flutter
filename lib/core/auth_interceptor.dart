import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskflowapp/core/utils/constants.dart';

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

  Future<void> _clearTokens() async {
    await storage.delete(key: StorageKeys.accessToken);
    await storage.delete(key: StorageKeys.refreshToken);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    
    if (options.extra[RequestExtraKeys.skipAuthInterceptor] == true) {
      return handler.next(options);
    }
    final token = await storage.read(key: StorageKeys.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers[HttpHeadersConst.authorization] =
          '${HttpHeadersConst.bearerPrefix}$token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.requestOptions.extra[RequestExtraKeys.skipAuthInterceptor] == true) {
      return super.onError(err, handler);
    }


    if (err.response?.statusCode == 401 &&
        err.requestOptions.extra[RequestExtraKeys.retried] != true) {
      err.requestOptions.extra[RequestExtraKeys.retried] = true;

      try {
        final newToken = await tokenRefresher.refreshAccessToken();
        if (newToken == null) {
          await _clearTokens();
          log('Session expired: refresh token unavailable/invalid.');
          return handler.next(err);
        }

        err.requestOptions.headers[HttpHeadersConst.authorization] =
            '${HttpHeadersConst.bearerPrefix}$newToken';
        final response = await dio.fetch(err.requestOptions);
        return handler.resolve(response);
      } catch (e, stack) {
        log('Refresh token failed: $e\n$stack');
        await _clearTokens();
        return handler.next(err);
      }
    }

    super.onError(err, handler);
  }
}