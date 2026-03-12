import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/enums.dart';

part 'task.freezed.dart';
part 'task.g.dart';

@freezed
sealed class Task with _$Task {
  const factory Task({
    @JsonKey(name: "id") required String taskId,
    @JsonKey(name: "title") required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String authorId,
    String? priority,
    String? categoryId,
    @Default(TaskStatusEnum.OPEN) TaskStatusEnum status,
    @Default(SyncStatus.SYNCED) SyncStatus syncStatus
  })=_Task;
  factory Task.fromJson(Map<String, dynamic>json) =>_$TaskFromJson(json);
}