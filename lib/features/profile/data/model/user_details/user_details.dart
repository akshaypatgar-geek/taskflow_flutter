import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details.freezed.dart';
part 'user_details.g.dart';

@freezed
sealed class UserDetails with _$UserDetails{
  const factory UserDetails({
    @JsonKey(name: "id") required String userId,
    @JsonKey(name: "name") String? userName,
    @JsonKey(name: "email") required String userEmail,
    @JsonKey(name: "status") String? userStatus,
    String? profilePicture

  }) = _UserDetails;
  factory UserDetails.fromJson(Map<String, dynamic>json) => _$UserDetailsFromJson(json);
}