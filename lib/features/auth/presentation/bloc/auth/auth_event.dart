part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class CheckSessionEvent extends AuthEvent {}

class AuthInitiateLogInEvent extends AuthEvent {
  final String email;
  final String password;

  AuthInitiateLogInEvent({required this.email, required this.password});
}

class InitiateSignUpEvent extends AuthEvent{
  final String email;
  final String password;

  InitiateSignUpEvent({required this.email, required this.password});
}
