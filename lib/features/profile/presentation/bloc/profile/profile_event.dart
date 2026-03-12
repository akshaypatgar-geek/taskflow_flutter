part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class GetProfileDetailsEvent extends ProfileEvent{}

class UpdateProfileEvent extends ProfileEvent{
  final String? name;
  final String? profilePicture;

  UpdateProfileEvent({ this.name,  this.profilePicture});
}

class LogOutUserEvent extends ProfileEvent {
}
