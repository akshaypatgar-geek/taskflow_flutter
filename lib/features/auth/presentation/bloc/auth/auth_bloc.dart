import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/logout_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/sign_up_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.checkSessionUseCase,
    required this.loginUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<CheckSessionEvent>(_checkSession);
    on<AuthInitiateLogInEvent>(_initiateLogIn);
    on<InitiateSignUpEvent>(_signUp);
    on<UserLogOutEvent>(_initiateLogOut);
  }

  final CheckSessionUseCase checkSessionUseCase;
  final LoginUseCase loginUseCase;
  final SignUpUseCase signUpUseCase;
  final LogoutUseCase logoutUseCase;

  Future<void> _checkSession(CheckSessionEvent event, Emitter<AuthState> emit) async {
    final isAuthenticated = await checkSessionUseCase();
  
    if (isAuthenticated) {
  
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _initiateLogIn(
    AuthInitiateLogInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoggingIn());

    final result = await loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(AuthLoginFailed(errorMessage: failure.message)),
      (_) => emit(AuthAuthenticated()),
    );
  }

  Future<void> _signUp(InitiateSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoggingIn());

    final result = await signUpUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(SignUpFailed(errorMessage: failure.message)),
      (_) => emit(SignUpSuccess()),
    );
  }

  Future<void> _initiateLogOut(UserLogOutEvent event, Emitter<AuthState> emit) async {
    await logoutUseCase();
    add(CheckSessionEvent());
  }
}
