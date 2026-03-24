import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/features/profile/domain/entities/user_details/user_details.dart';
import 'package:taskflowapp/features/profile/domain/usecases/get_profile_details_use_case.dart';
import 'package:taskflowapp/features/profile/domain/usecases/update_profile_use_case.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc({
    // required this.getCachedProfileUseCase,
    required this.getProfileDetailsUseCase,
    required this.updateProfileUseCase,
  }) : super(ProfileInitial()) {
    on<GetProfileDetailsEvent>(_getProfileDetails);
    on<UpdateProfileEvent>(_updateProfile);
  }

  // final GetCachedProfileUseCase getCachedProfileUseCase;
  final GetProfileDetailsUseCase getProfileDetailsUseCase;
  final UpdateProfileUseCase updateProfileUseCase;

  Future<void> _getProfileDetails(
    GetProfileDetailsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    final result = await getProfileDetailsUseCase();
    result.fold(
      (l) => emit(UserProfileFailedState(errorMessage: l.message)),
      (r) => emit(UserDetailsReceivedState(userDetails: r)),
    );
  }

  UserDetails? _currentUserDetails() {
    final current = state;
    if (current is UserDetailsReceivedState) return current.userDetails;
    if (current is UpdateUserDetailsLoadingState) return current.userDetails;
    if (current is UpdateUserDetailsFailedState) return current.userDetails;
    return null;
  }

  Future<void> _updateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final existingUser = _currentUserDetails();
    if (existingUser == null) return;

    emit(UpdateUserDetailsLoadingState(userDetails: existingUser));
    final result = await updateProfileUseCase(
      name: event.name,
      profilePicture: event.profilePicture,
    );
    result.fold(
      (l) => emit(UpdateUserDetailsFailedState(
        userDetails: existingUser,
        errorMessage: l.message,
      )),
      (r) => emit(UserDetailsReceivedState(userDetails: r)),
    );
  }
}
