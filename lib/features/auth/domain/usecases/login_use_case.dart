import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_tokens/auth_tokens.dart';
import 'package:taskflowapp/features/auth/domain/repository/auth_repository_interface.dart';


class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthTokens>> call({
    required String email,
    required String password,
  }) async {
    
    return _repository.login(
      email: email,
      password: password,
    );
  }
}
