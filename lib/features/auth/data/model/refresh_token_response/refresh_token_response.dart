import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_token_response.freezed.dart';
part 'refresh_token_response.g.dart';

@freezed
sealed class RefreshTokenResponse with _$RefreshTokenResponse{
const factory RefreshTokenResponse({
  @JsonKey(name: "access_token") required String accessToken,
  @JsonKey(name: "refresh_token") required String refreshToken
}) = _RefreshTokenResponse;
factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
_$RefreshTokenResponseFromJson(json);
}