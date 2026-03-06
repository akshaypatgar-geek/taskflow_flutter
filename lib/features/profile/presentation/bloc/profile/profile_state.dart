part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {

}

class UserDetailsReceivedState extends ProfileState{
  final UserDetails userDetails;

  UserDetailsReceivedState({required this.userDetails});
}

class UserProfileFailedState extends ProfileState {
  final String errorMessage;

  UserProfileFailedState({required this.errorMessage});
}

class UpdateUserDetailsLoadingState extends ProfileState {

}

