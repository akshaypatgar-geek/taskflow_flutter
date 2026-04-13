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

  static String firebaseApiKey = '';
  static String firebaseAppId = '';
  static String firebaseMessagingSenderId = '';
  static String firebaseProjectId = '';
  static String firebaseAuthDomain = '';
  static String firebaseStorageBucket = '';
  static String firebaseMeasurementId = '';
  static String vapidKey = '';

  static Future<void> init() async {
    await _loadEnv();
    if (kIsWeb) {
      await _loadWebConfig();
    }
  }

  static Future<void> _loadEnv() async {
    try {
      await dotenv.load(fileName: '.env');
      baseUrl = dotenv.maybeGet('BASE_URL') ?? baseUrl;
      websocketUrl = dotenv.maybeGet('WEBSOCKET_URL') ?? websocketUrl;
      firebaseApiKey = dotenv.maybeGet('FIREBASE_API_KEY') ?? '';
      firebaseAppId = dotenv.maybeGet('FIREBASE_APP_ID') ?? '';
      firebaseMessagingSenderId = dotenv.maybeGet('FIREBASE_MESSAGING_SENDER_ID') ?? '';
      firebaseProjectId = dotenv.maybeGet('FIREBASE_PROJECT_ID') ?? '';
      firebaseAuthDomain = dotenv.maybeGet('FIREBASE_AUTH_DOMAIN') ?? '';
      firebaseStorageBucket = dotenv.maybeGet('FIREBASE_STORAGE_BUCKET') ?? '';
      firebaseMeasurementId = dotenv.maybeGet('FIREBASE_MEASUREMENT_ID') ?? '';
      vapidKey = dotenv.maybeGet('FIREBASE_VAPID_KEY') ?? '';
    } catch (_) {
      // Keep fallback values when .env is missing/invalid.
    }
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
        firebaseApiKey = (data['firebaseApiKey'] as String?) ?? firebaseApiKey;
        firebaseAppId = (data['firebaseAppId'] as String?) ?? firebaseAppId;
        firebaseMessagingSenderId = (data['firebaseMessagingSenderId'] as String?) ?? firebaseMessagingSenderId;
        firebaseProjectId = (data['firebaseProjectId'] as String?) ?? firebaseProjectId;
        firebaseAuthDomain = (data['firebaseAuthDomain'] as String?) ?? firebaseAuthDomain;
        firebaseStorageBucket = (data['firebaseStorageBucket'] as String?) ?? firebaseStorageBucket;
        firebaseMeasurementId = (data['firebaseMeasurementId'] as String?) ?? firebaseMeasurementId;
        vapidKey = (data['vapidKey'] as String?) ?? vapidKey;
      }
    } catch (_) {
      // Keep fallback values when config file is missing/invalid.
    }
  }
}
