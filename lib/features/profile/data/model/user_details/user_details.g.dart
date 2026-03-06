// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDetails _$UserDetailsFromJson(Map<String, dynamic> json) => _UserDetails(
  userId: json['id'] as String,
  userName: json['name'] as String?,
  userEmail: json['email'] as String,
  userStatus: json['status'] as String?,
  profilePicture: json['profilePicture'] as String?,
);

Map<String, dynamic> _$UserDetailsToJson(_UserDetails instance) =>
    <String, dynamic>{
      'id': instance.userId,
      'name': instance.userName,
      'email': instance.userEmail,
      'status': instance.userStatus,
      'profilePicture': instance.profilePicture,
    };
