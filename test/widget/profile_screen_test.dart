import 'package:dartz/dartz.dart';
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
import 'package:taskflowapp/features/profile/domain/entities/user_details/user_details.dart';
import 'package:taskflowapp/features/profile/domain/usecases/get_profile_details_use_case.dart';
import 'package:taskflowapp/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:taskflowapp/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:taskflowapp/features/profile/presentation/screen/profile_screen.dart';

import '../helpers/widget_test_helpers.dart';

class MockCheckSessionUseCase extends Mock implements CheckSessionUseCase {}
class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockSignUpUseCase extends Mock implements SignUpUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockDisconnectWebSocketUseCase extends Mock
    implements DisconnectWebSocketUseCase {}
class MockGetProfileDetailsUseCase extends Mock implements GetProfileDetailsUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

void main() {
  late AuthBloc authBloc;
  late ProfileBloc profileBloc;
  late MockGetProfileDetailsUseCase mockGetProfile;

  setUp(() {
    authBloc = AuthBloc(
      checkSessionUseCase: MockCheckSessionUseCase(),
      loginUseCase: MockLoginUseCase(),
      signUpUseCase: MockSignUpUseCase(),
      logoutUseCase: MockLogoutUseCase(),
      disconnectWebSocketUseCase: MockDisconnectWebSocketUseCase(),
    );
    mockGetProfile = MockGetProfileDetailsUseCase();
    profileBloc = ProfileBloc(
      getProfileDetailsUseCase: mockGetProfile,
      updateProfileUseCase: MockUpdateProfileUseCase(),
    );
  });

  tearDown(() {
    authBloc.close();
    profileBloc.close();
  });

  group('ProfileScreen', () {
    testWidgets('renders Profile title and loading initially', (tester) async {
      await pumpTestWidget(
        tester,
        const ProfileScreen(),
        authBloc: authBloc,
        profileBloc: profileBloc,
      );

      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('shows user details when loaded', (tester) async {
      final user = UserDetails(
        userId: '1',
        userEmail: 'test@example.com',
        userName: 'Test User',
      );
      when(() => mockGetProfile()).thenAnswer((_) async => Right(user));

      await pumpTestWidget(
        tester,
        const ProfileScreen(),
        authBloc: authBloc,
        profileBloc: profileBloc,
      );
      profileBloc.add(GetProfileDetailsEvent());
      await tester.pumpAndSettle();

      expect(find.text('Test User'), findsOneWidget);
      expect(find.bySemanticsLabel('Logout'), findsOneWidget);
      expect(find.bySemanticsLabel('Categories'), findsOneWidget);
    });
  });
}
