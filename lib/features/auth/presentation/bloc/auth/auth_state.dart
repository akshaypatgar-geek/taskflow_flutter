part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthSessionExpired extends AuthUnauthenticated {
  final String message;

  AuthSessionExpired({this.message = 'Session expired. Please log in again.'});

  @override
  List<Object?> get props => [message];
}

class AuthLoginFailed extends AuthState {
  final String errorMessage;

  const AuthLoginFailed({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class AuthLoggingIn extends AuthState {}

class SignUpSuccess extends AuthState {}

class SignUpFailed extends AuthState {
  final String errorMessage;

  const SignUpFailed({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
