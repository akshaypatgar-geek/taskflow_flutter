import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_tokens/auth_tokens.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_user/auth_user.dart';


abstract interface class AuthRepository {
  Future<bool> hasValidSession();

  
  Future<String?> getAccessToken();

 
  Future<String?> refreshToken();


  Future<Either<Failure, AuthTokens>> login({
    required String email,
    required String password,
  });

  
  Future<Either<Failure, AuthUser>> signUp({
    required String email,
    required String password,
  });

  Future<void> logout();
}
