import 'package:taskflowapp/features/auth/domain/repository/auth_repository_interface.dart';


class LogoutUseCase {
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  Future<void> call() async {
    await _repository.logout();
  }
}
