import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_details_model.freezed.dart';
part 'user_details_model.g.dart';

@freezed
abstract class UserDetailsModel with _$UserDetailsModel{
  const factory UserDetailsModel({
    @JsonKey(name: 'id') required String userId,
    @JsonKey(name: 'name') String? userName,
    @JsonKey(name: 'email') required String userEmail,
    @JsonKey(name: 'status') String? userStatus,
    String? profilePicture

  }) = _UserDetailsModel;
  factory UserDetailsModel.fromJson(Map<String, dynamic>json) => _$UserDetailsModelFromJson(json);
}