import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/features/profile/data/model/user_details/user_details.dart';

import '../../../data/repository/profile_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  ProfileBloc({required this.repository}) : super(ProfileInitial()) {
    on<GetProfileDetailsEvent>(_getProfileDetails);
    on<UpdateProfileEvent>(_updateProfile);
  }

  void _getProfileDetails(GetProfileDetailsEvent event, Emitter<ProfileState> emit)async {
    emit(ProfileLoadingState());
    final result = await repository.getUserDetails();
    result.fold((l) => emit(UserProfileFailedState(errorMessage: l.message)), (r) => emit(UserDetailsReceivedState(userDetails: r)),);
  }



  void _updateProfile(UpdateProfileEvent event, Emitter<ProfileState> emit) async{
    emit(UpdateUserDetailsLoadingState());
    final result = await repository.updateUserDetails(name: event.name, profilePicture: event.profilePicture);
    result.fold((l) => emit(UserProfileFailedState(errorMessage: l.message)), (r) => emit(UserDetailsReceivedState(userDetails: r)),);
  }
}
