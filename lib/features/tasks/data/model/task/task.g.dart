// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  taskId: json['id'] as String,
  title: json['title'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  authorId: json['authorId'] as String,
  priority: json['priority'] as String?,
  categoryId: json['categoryId'] as String?,
  status:
      $enumDecodeNullable(_$TaskStatusEnumEnumMap, json['status']) ??
      TaskStatusEnum.OPEN,
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.taskId,
  'title': instance.title,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'authorId': instance.authorId,
  'priority': instance.priority,
  'categoryId': instance.categoryId,
  'status': _$TaskStatusEnumEnumMap[instance.status]!,
};

const _$TaskStatusEnumEnumMap = {
  TaskStatusEnum.OPEN: 'OPEN',
  TaskStatusEnum.IN_PROGRESS: 'IN_PROGRESS',
  TaskStatusEnum.CLOSED: 'CLOSED',
};
