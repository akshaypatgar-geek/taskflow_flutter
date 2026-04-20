import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:taskflowapp/core/utils/constants.dart';

class SessionManager {
  final FlutterSecureStorage storage;

  SessionManager({required this.storage});

  Future<void> saveAccessToken(String token) async {
    await storage.write(key: StorageKeys.accessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: StorageKeys.accessToken);
  }

  Future<bool> hasValidSession() async {
    final token = await storage.read(key: StorageKeys.accessToken);

    if (token == null) return false;

    final isExpired = JwtDecoder.isExpired(token);

    return !isExpired;
  }

  Future<void> clearSession() async {
    await storage.delete(key: StorageKeys.accessToken);
  }
}
