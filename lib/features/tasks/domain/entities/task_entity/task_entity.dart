

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_status.dart';
import 'package:taskflowapp/features/tasks/domain/entities/sync_status.dart';

part 'task_entity.freezed.dart';

@freezed
abstract class TaskEntity with _$TaskEntity{
  const factory TaskEntity({
    required String taskId,
    required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String authorId,
    String? priority,
    String? categoryId,
    @Default( TaskStatusEnum.OPEN) TaskStatusEnum? status,
    @Default(SyncStatus.SYNCED) SyncStatus? syncStatus,
  }) = _TaskEntity;
}