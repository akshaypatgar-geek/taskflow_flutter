import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/profile/domain/entities/user_details/user_details.dart';
import 'package:taskflowapp/features/profile/domain/usecases/get_profile_details_use_case.dart';
import 'package:taskflowapp/features/profile/domain/usecases/update_profile_use_case.dart';
import 'package:taskflowapp/features/profile/presentation/bloc/profile/profile_bloc.dart';

class MockGetProfileDetailsUseCase extends Mock implements GetProfileDetailsUseCase {}
class MockUpdateProfileUseCase extends Mock implements UpdateProfileUseCase {}

void main() {
  late ProfileBloc profileBloc;
  late MockGetProfileDetailsUseCase mockGetProfileDetailsUseCase;
  late MockUpdateProfileUseCase mockUpdateProfileUseCase;

  final testUserDetails = UserDetails(
    userId: 'user1',
    userEmail: 'test@example.com',
    userName: 'Test User',
    userStatus: 'active',
    profilePicture: null,
  );

  setUp(() {
    mockGetProfileDetailsUseCase = MockGetProfileDetailsUseCase();
    mockUpdateProfileUseCase = MockUpdateProfileUseCase();

    profileBloc = ProfileBloc(
      getProfileDetailsUseCase: mockGetProfileDetailsUseCase,
      updateProfileUseCase: mockUpdateProfileUseCase,
    );
  });

  tearDown(() => profileBloc.close());

  group('ProfileBloc', () {
    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoadingState, UserDetailsReceivedState] when GetProfileDetailsEvent succeeds',
      build: () {
        when(() => mockGetProfileDetailsUseCase())
            .thenAnswer((_) async => Right(testUserDetails));
        return profileBloc;
      },
      act: (bloc) => bloc.add(GetProfileDetailsEvent()),
      expect: () => [
        ProfileLoadingState(),
        UserDetailsReceivedState(userDetails: testUserDetails),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [ProfileLoadingState, UserProfileFailedState] when GetProfileDetailsEvent fails',
      build: () {
        when(() => mockGetProfileDetailsUseCase())
            .thenAnswer((_) async => const Left(ServerFailure('Failed to load')));
        return profileBloc;
      },
      act: (bloc) => bloc.add(GetProfileDetailsEvent()),
      expect: () => [
        ProfileLoadingState(),
        UserProfileFailedState(errorMessage: 'Failed to load'),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [UpdateUserDetailsLoadingState, UserDetailsReceivedState] when UpdateProfileEvent succeeds',
      build: () {
        final updatedUser = testUserDetails.copyWith(userName: 'Updated Name');
        when(() => mockUpdateProfileUseCase(
              name: any(named: 'name'),
              profilePicture: any(named: 'profilePicture'),
            )).thenAnswer((_) async => Right(updatedUser));
        return profileBloc;
      },
      seed: () => UserDetailsReceivedState(userDetails: testUserDetails),
      act: (bloc) => bloc.add(UpdateProfileEvent(name: 'Updated Name')),
      expect: () => [
        UpdateUserDetailsLoadingState(userDetails: testUserDetails),
        UserDetailsReceivedState(userDetails: testUserDetails.copyWith(userName: 'Updated Name')),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [UpdateUserDetailsLoadingState, UpdateUserDetailsFailedState] when UpdateProfileEvent fails',
      build: () {
        when(() => mockUpdateProfileUseCase(
              name: any(named: 'name'),
              profilePicture: any(named: 'profilePicture'),
            )).thenAnswer((_) async => const Left(ServerFailure('Update failed')));
        return profileBloc;
      },
      seed: () => UserDetailsReceivedState(userDetails: testUserDetails),
      act: (bloc) => bloc.add(UpdateProfileEvent(name: 'New Name')),
      expect: () => [
        UpdateUserDetailsLoadingState(userDetails: testUserDetails),
        UpdateUserDetailsFailedState(
          userDetails: testUserDetails,
          errorMessage: 'Update failed',
        ),
      ],
    );

    blocTest<ProfileBloc, ProfileState>(
      'does not emit when UpdateProfileEvent is dispatched without user details',
      build: () => profileBloc,
      act: (bloc) => bloc.add(UpdateProfileEvent(name: 'New Name')),
      expect: () => [],
    );
  });
}
