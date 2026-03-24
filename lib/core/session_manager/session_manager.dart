import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SessionManager {
  final FlutterSecureStorage storage;

  SessionManager({required this.storage});

  static const _accessTokenKey = "access_token";

  Future<void> saveAccessToken(String token) async {
    await storage.write(
      key: _accessTokenKey,
      value: token,
    );
  }


  Future<String?> getAccessToken() async {
    return await storage.read(key: _accessTokenKey);
  }

  
  Future<bool> hasValidSession() async {
    final token = await storage.read(key: _accessTokenKey);

    if (token == null) return false;

    final isExpired = JwtDecoder.isExpired(token);

    return !isExpired;
  }

  Future<void> clearSession() async {
    await storage.delete(key: _accessTokenKey);
  }
}