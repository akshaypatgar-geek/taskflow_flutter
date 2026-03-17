import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/features/profile/data/model/user_details/user_details.dart';

import '../../../data/repository/profile_repository.dart';
import '../../../local/user_profile_local_repository/user_profile_local_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  final UserProfileLocalRepository localRepository;

  ProfileBloc({required this.repository, required this.localRepository})
      : super(ProfileInitial()) {
    on<GetProfileDetailsEvent>(_getProfileDetails);
    on<UpdateProfileEvent>(_updateProfile);
  }

  void _getProfileDetails(
    GetProfileDetailsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoadingState());

    final cachedUser = localRepository.getCachedUser();
    if (cachedUser != null) {
      emit(UserDetailsReceivedState(userDetails: cachedUser));
    }

    final result = await repository.getUserDetails();
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

  void _updateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final existingUser = _currentUserDetails();
    if (existingUser == null) return;

    emit(UpdateUserDetailsLoadingState(userDetails: existingUser));
    final result = await repository.updateUserDetails(
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
