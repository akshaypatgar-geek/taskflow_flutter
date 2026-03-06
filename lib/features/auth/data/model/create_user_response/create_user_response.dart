import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_user_response.freezed.dart';
part 'create_user_response.g.dart';

@freezed
sealed class CreateUserResponse with _$CreateUserResponse{
  const factory CreateUserResponse({
    @JsonKey(name: "id")required String userId,
    @JsonKey(name: "email") required String userEmail,
  }) = _CreateUserResponse;
  factory CreateUserResponse.fromJson(Map<String, dynamic> json) =>_$CreateUserResponseFromJson(json);
}