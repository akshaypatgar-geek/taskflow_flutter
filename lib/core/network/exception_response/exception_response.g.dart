// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exception_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExceptionResponse _$ExceptionResponseFromJson(Map<String, dynamic> json) =>
    _ExceptionResponse(
      statusCode: (json['statusCode'] as num).toInt(),
      errorMessage: json['Message'] as String,
    );

Map<String, dynamic> _$ExceptionResponseToJson(_ExceptionResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'Message': instance.errorMessage,
    };
