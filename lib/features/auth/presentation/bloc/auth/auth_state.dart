part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthLoginFailed extends AuthState {
  final String errorMessage;

  AuthLoginFailed({required this.errorMessage});
}

class AuthLoggingIn extends AuthState {
}

class SignUpSuccess extends AuthState{}

class SignUpFailed extends AuthState{
  final String errorMessage;

  SignUpFailed({required this.errorMessage});
}


