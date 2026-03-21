// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDetailsModel _$UserDetailsModelFromJson(Map<String, dynamic> json) =>
    _UserDetailsModel(
      userId: json['id'] as String,
      userName: json['name'] as String?,
      userEmail: json['email'] as String,
      userStatus: json['status'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$UserDetailsModelToJson(_UserDetailsModel instance) =>
    <String, dynamic>{
      'id': instance.userId,
      'name': instance.userName,
      'email': instance.userEmail,
      'status': instance.userStatus,
      'profilePicture': instance.profilePicture,
    };
