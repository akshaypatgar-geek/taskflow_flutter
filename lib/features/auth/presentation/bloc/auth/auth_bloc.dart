import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:email_validator/email_validator.dart';
import 'package:taskflowapp/features/auth/data/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;
  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<CheckSessionEvent>(_checkSession);
    on<AuthInitiateLogInEvent>(_initiateLogIn);
    on<InitiateSignUpEvent>(_signUp);
  }

  void _checkSession(CheckSessionEvent event, Emitter<AuthState> emit) async{
  final hasSession = await repository.sessionManager.hasValidSession();

  if (hasSession) {
   return emit(AuthAuthenticated());
  } 
  final newToken = await repository.refreshToken(); // uses refresh token internally
  if (newToken != null) {
    emit(AuthAuthenticated());
  } else {
    emit(AuthUnauthenticated());
  }
  
  }

 void _initiateLogIn(AuthInitiateLogInEvent event, Emitter<AuthState>emit) async {
  emit(AuthLoggingIn());
  bool isEmailValid = EmailValidator.validate(event.email);
  log("isvalid :$isEmailValid");
  if(!isEmailValid)return emit(AuthLoginFailed(errorMessage: "Invalid email"));
  if(event.password.isEmpty)return emit(AuthLoginFailed(errorMessage: "Enter passowrd"));
  log("calling api ");
  final response  = await repository.login(email: event.email, password: event.password);
  log("response :$response");
  response.fold((l) => emit(AuthLoginFailed(errorMessage: l.message)), (r) {
    emit(AuthAuthenticated());
  },);
 }

 void _signUp(InitiateSignUpEvent event, Emitter<AuthState> emit) async{
  emit(AuthLoggingIn());
  bool isEmailValid = EmailValidator.validate(event.email);

  if(!isEmailValid) return emit(SignUpFailed(errorMessage: "Invalid email"));
  if(event.password.isEmpty)return emit(SignUpFailed(errorMessage: "Enter passowrd"));
  final result = await repository.signUp(email: event.email, password: event.password);
  result.fold((l) {
    emit(SignUpFailed(errorMessage: l.message));
  }, (r) {
    emit(SignUpSuccess());
  },);
 }
}
