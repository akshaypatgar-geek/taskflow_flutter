import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_user/auth_user.dart';
import 'package:taskflowapp/features/auth/domain/repository/auth_repository_interface.dart';


class SignUpUseCase {
  SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthUser>> call({
    required String email,
    required String password,
  }) async {
    return _repository.signUp(
      email: email.trim(),
      password: password,
    );
  }
}
