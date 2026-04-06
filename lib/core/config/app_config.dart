import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized runtime config for both web and mobile.
///
/// - Web: tries `/app_config.json` first, then falls back to compile-time
///   `--dart-define` values and finally localhost defaults.
/// - Mobile: loads `.env` and falls back to compile-time/default values.
abstract final class AppConfig {
  AppConfig._();

  static String baseUrl = const String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static String websocketUrl = const String.fromEnvironment(
    'WEBSOCKET_URL',
    defaultValue: 'ws://localhost:3000',
  );

  static Future<void> init() async {
    if (kIsWeb) {
      await _loadWebConfig();
      return;
    }
    await _loadMobileEnv();
  }

  static Future<void> _loadMobileEnv() async {
    await dotenv.load(fileName: '.env');
    baseUrl = dotenv.maybeGet('BASE_URL') ?? baseUrl;
    websocketUrl = dotenv.maybeGet('WEBSOCKET_URL') ?? websocketUrl;
  }

  static Future<void> _loadWebConfig() async {
    try {
      final response = await Dio().getUri<dynamic>(
        Uri.base.resolve('app_config.json'),
        options: Options(responseType: ResponseType.plain),
      );
      final data = jsonDecode(response.data as String);
      if (data is Map<String, dynamic>) {
        baseUrl = (data['baseUrl'] as String?) ?? baseUrl;
        websocketUrl = (data['websocketUrl'] as String?) ?? websocketUrl;
      }
    } catch (_) {
      // Keep fallback values when config file is missing/invalid.
    }
  }
}
