import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user_model.freezed.dart';
part 'auth_user_model.g.dart';

@freezed
abstract class AuthUserModel with _$AuthUserModel {
  const factory AuthUserModel({
    @JsonKey(name: 'id') required String userId,
    @JsonKey(name: 'email') required String userEmail,
  }) = _AuthUserModel;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);
}
