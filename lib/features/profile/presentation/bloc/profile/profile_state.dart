part of 'profile_bloc.dart';

@immutable
sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class UserDetailsReceivedState extends ProfileState {
  final UserDetails userDetails;

  UserDetailsReceivedState({required this.userDetails});

  @override
  List<Object?> get props => [userDetails];
}

class UserProfileFailedState extends ProfileState {
  final String errorMessage;

  UserProfileFailedState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class UpdateUserDetailsLoadingState extends ProfileState {
  final UserDetails userDetails;

  UpdateUserDetailsLoadingState({required this.userDetails});

  @override
  List<Object?> get props => [userDetails];
}

class UpdateUserDetailsFailedState extends ProfileState {
  final UserDetails userDetails;
  final String errorMessage;

  UpdateUserDetailsFailedState({
    required this.userDetails,
    required this.errorMessage,
  });

  @override
  List<Object?> get props => [userDetails, errorMessage];
}
