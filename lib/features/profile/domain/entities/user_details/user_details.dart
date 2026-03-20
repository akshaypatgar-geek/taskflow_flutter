import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details.freezed.dart';


@freezed
abstract class UserDetails with _$UserDetails {
  const factory UserDetails({
    required String userId,
    required String userEmail,
    String? userName,
    String? userStatus,
    String? profilePicture,
  }) = _UserDetails;
}
