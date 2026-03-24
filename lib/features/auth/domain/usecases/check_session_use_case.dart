import 'dart:developer';

import 'package:taskflowapp/features/auth/domain/repository/auth_repository_interface.dart';

enum SessionCheckResult { authenticated, unauthenticated, expired }

class CheckSessionUseCase {
  CheckSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<SessionCheckResult> call() async {
    try {
      final hasSession = await _repository.hasValidSession();
      if (hasSession) return SessionCheckResult.authenticated;

      final accessToken = await _repository.getAccessToken();
      if (accessToken == null) return SessionCheckResult.unauthenticated;

      final newToken = await _repository.refreshToken();
      if (newToken != null) return SessionCheckResult.authenticated;

      log('Session check failed: unable to refresh access token.');
      return SessionCheckResult.expired;
    } catch (e, stack) {
      log('CheckSessionUseCase failed: $e\n$stack');
      return SessionCheckResult.unauthenticated;
    }
  }
}
