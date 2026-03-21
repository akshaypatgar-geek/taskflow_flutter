// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => _TaskModel(
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
  syncStatus:
      $enumDecodeNullable(_$SyncStatusEnumMap, json['syncStatus']) ??
      SyncStatus.SYNCED,
);

Map<String, dynamic> _$TaskModelToJson(_TaskModel instance) =>
    <String, dynamic>{
      'id': instance.taskId,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'authorId': instance.authorId,
      'priority': instance.priority,
      'categoryId': instance.categoryId,
      'status': _$TaskStatusEnumEnumMap[instance.status]!,
      'syncStatus': _$SyncStatusEnumMap[instance.syncStatus]!,
    };

const _$TaskStatusEnumEnumMap = {
  TaskStatusEnum.OPEN: 'OPEN',
  TaskStatusEnum.IN_PROGRESS: 'IN_PROGRESS',
  TaskStatusEnum.COMPLETED: 'COMPLETED',
};

const _$SyncStatusEnumMap = {
  SyncStatus.SYNCED: 'SYNCED',
  SyncStatus.PENDING: 'PENDING',
};
