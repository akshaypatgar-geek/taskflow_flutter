import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/core/domain/disconnect_websocket_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/check_session_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/login_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/logout_use_case.dart';
import 'package:taskflowapp/features/auth/domain/usecases/sign_up_use_case.dart';
import 'package:taskflowapp/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:taskflowapp/features/auth/presentation/screen/log_in_screen.dart';

import '../helpers/widget_test_helpers.dart';

class MockCheckSessionUseCase extends Mock implements CheckSessionUseCase {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSignUpUseCase extends Mock implements SignUpUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockDisconnectWebSocketUseCase extends Mock
    implements DisconnectWebSocketUseCase {}

void main() {
  late AuthBloc authBloc;

  setUp(() {
    authBloc = AuthBloc(
      checkSessionUseCase: MockCheckSessionUseCase(),
      loginUseCase: MockLoginUseCase(),
      signUpUseCase: MockSignUpUseCase(),
      logoutUseCase: MockLogoutUseCase(),
      disconnectWebSocketUseCase: MockDisconnectWebSocketUseCase(),
    );
  });

  tearDown(() => authBloc.close());

  group('LogInScreen', () {
    testWidgets('renders welcome text and Log In button', (tester) async {
      await pumpTestWidget(tester, const LogInScreen(), authBloc: authBloc);

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('Sign in to your account'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
      expect(find.text('Sign Up instead'), findsOneWidget);
    });

    testWidgets('renders email and password fields', (tester) async {
      await pumpTestWidget(tester, const LogInScreen(), authBloc: authBloc);

      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('Sign Up instead navigates to sign up', (tester) async {
      final router = createTestRouter(
        home: BlocProvider.value(
          value: authBloc,
          child: const LogInScreen(),
        ),
        authBloc: authBloc,
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: ThemeData.light(),
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Sign Up instead'));
      await tester.pumpAndSettle();

      expect(router.routerDelegate.currentConfiguration.fullPath, contains('signup'));
    });
  });
}
