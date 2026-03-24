import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_tokens/auth_tokens.dart';
import 'package:taskflowapp/features/auth/domain/entities/auth_user/auth_user.dart';
import 'package:taskflowapp/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/logout_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';

class MockCheckSessionUseCase extends Mock implements CheckSessionUseCase {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSignUpUseCase extends Mock implements SignUpUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late AuthBloc authBloc;
  late MockCheckSessionUseCase mockCheckSessionUseCase;
  late MockLoginUseCase mockLoginUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockCheckSessionUseCase = MockCheckSessionUseCase();
    mockLoginUseCase = MockLoginUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockLogoutUseCase = MockLogoutUseCase();

    authBloc = AuthBloc(
      checkSessionUseCase: mockCheckSessionUseCase,
      loginUseCase: mockLoginUseCase,
      signUpUseCase: mockSignUpUseCase,
      logoutUseCase: mockLogoutUseCase,
    );
  });

  tearDown(() => authBloc.close());

  group('AuthBloc', () {
    blocTest<AuthBloc, AuthState>(
      'emits [AuthAuthenticated] when CheckSessionEvent and session is valid',
      build: () {
        when(() => mockCheckSessionUseCase()).thenAnswer((_) async => true);
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckSessionEvent()),
      expect: () => [AuthAuthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when CheckSessionEvent and session is invalid',
      build: () {
        when(() => mockCheckSessionUseCase()).thenAnswer((_) async => false);
        return authBloc;
      },
      act: (bloc) => bloc.add(CheckSessionEvent()),
      expect: () => [AuthUnauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoggingIn, AuthAuthenticated] when login succeeds',
      build: () {
        when(() => mockLoginUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(AuthTokens(accessToken: 'token', refreshToken: 'refresh')));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthInitiateLogInEvent(
        email: 'test@example.com',
        password: 'password123',
      )),
      expect: () => [
        AuthLoggingIn(),
        AuthAuthenticated(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoggingIn, AuthLoginFailed] when login fails',
      build: () {
        when(() => mockLoginUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left(UnauthorizedFailure('Invalid credentials')));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthInitiateLogInEvent(
        email: 'test@example.com',
        password: 'wrong',
      )),
      expect: () => [
        AuthLoggingIn(),
        AuthLoginFailed(errorMessage: 'Invalid credentials'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoggingIn, SignUpSuccess] when sign up succeeds',
      build: () {
        when(() => mockSignUpUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => Right(AuthUser(uaserId: '1', email: 'new@example.com')));
        return authBloc;
      },
      act: (bloc) => bloc.add(InitiateSignUpEvent(
        email: 'new@example.com',
        password: 'password123',
      )),
      expect: () => [
        AuthLoggingIn(),
        SignUpSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoggingIn, SignUpFailed] when sign up fails',
      build: () {
        when(() => mockSignUpUseCase(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async => const Left(ExistsFailure('Email already exists')));
        return authBloc;
      },
      act: (bloc) => bloc.add(InitiateSignUpEvent(
        email: 'existing@example.com',
        password: 'password123',
      )),
      expect: () => [
        AuthLoggingIn(),
        SignUpFailed(errorMessage: 'Email already exists'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthUnauthenticated] when UserLogOutEvent is dispatched',
      build: () {
        when(() => mockLogoutUseCase()).thenAnswer((_) async => {});
        when(() => mockCheckSessionUseCase()).thenAnswer((_) async => false);
        return authBloc;
      },
      act: (bloc) => bloc.add(UserLogOutEvent()),
      expect: () => [AuthUnauthenticated()],
    );
  });
}
