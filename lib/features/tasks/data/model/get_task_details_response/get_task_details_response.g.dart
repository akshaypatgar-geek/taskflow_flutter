// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_task_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GetTaskDetailsResponse _$GetTaskDetailsResponseFromJson(
  Map<String, dynamic> json,
) => _GetTaskDetailsResponse(
  task: Task.fromJson(json['task'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetTaskDetailsResponseToJson(
  _GetTaskDetailsResponse instance,
) => <String, dynamic>{'task': instance.task};
