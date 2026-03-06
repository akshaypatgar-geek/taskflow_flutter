// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_tasks_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ListTasksResponse _$ListTasksResponseFromJson(Map<String, dynamic> json) =>
    _ListTasksResponse(
      tasks: (json['tasks'] as List<dynamic>)
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['nextCursor'] as String?,
      hasNextPage: json['hasNextPage'] as bool,
    );

Map<String, dynamic> _$ListTasksResponseToJson(_ListTasksResponse instance) =>
    <String, dynamic>{
      'tasks': instance.tasks,
      'nextCursor': instance.nextCursor,
      'hasNextPage': instance.hasNextPage,
    };
