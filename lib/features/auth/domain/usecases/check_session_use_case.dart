import 'package:taskflowapp/features/auth/domain/repository/auth_repository_interface.dart';


class CheckSessionUseCase {
  CheckSessionUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> call() async {
    print("calling check session");
    try {
      final hasSession = await _repository.hasValidSession();
      if (hasSession) return true;
      
      final accessToken = await _repository.getAccessToken();
      if (accessToken == null) return false;

      final newToken = await _repository.refreshToken();
      if (newToken != null) return true;

      return true;
    } catch (_) {
      return false;
    }
  }
}
