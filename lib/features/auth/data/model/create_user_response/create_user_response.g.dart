// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateUserResponse _$CreateUserResponseFromJson(Map<String, dynamic> json) =>
    _CreateUserResponse(
      userId: json['id'] as String,
      userEmail: json['email'] as String,
    );

Map<String, dynamic> _$CreateUserResponseToJson(_CreateUserResponse instance) =>
    <String, dynamic>{'id': instance.userId, 'email': instance.userEmail};
