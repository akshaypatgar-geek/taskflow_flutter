import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/logout_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskflowapp/features/auth/presentation/screen/sign_up_screen.dart';

import '../helpers/widget_test_helpers.dart';

class MockCheckSessionUseCase extends Mock implements CheckSessionUseCase {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSignUpUseCase extends Mock implements SignUpUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc(
      checkSessionUseCase: MockCheckSessionUseCase(),
      loginUseCase: MockLoginUseCase(),
      signUpUseCase: MockSignUpUseCase(),
      logoutUseCase: MockLogoutUseCase(),
    );
  });

  tearDown(() => authBloc.close());

  group('SignUpScreen', () {
    testWidgets('renders Create Account and form fields', (tester) async {
      await pumpTestWidget(tester, const SignUpScreen(), authBloc: authBloc);

      expect(find.text('Create Account'), findsOneWidget);
      expect(find.text('Setup Your account'), findsOneWidget);
      expect(find.text('Enter your email and password'), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('has back button in app bar', (tester) async {
      await pumpTestWidget(tester, const SignUpScreen(), authBloc: authBloc);

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
