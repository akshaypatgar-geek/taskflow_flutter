import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/utils/enums.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
abstract class TaskModel with _$TaskModel {
  const factory TaskModel({
    @JsonKey(name: 'id') required String taskId,
    @JsonKey(name: 'title') required String title,
    required DateTime createdAt,
    required DateTime updatedAt,
    required String authorId,
    String? priority,
    String? categoryId,
    @Default(TaskStatusEnum.OPEN) TaskStatusEnum status,
    @Default(SyncStatus.SYNCED) SyncStatus syncStatus
  })=_TaskModel;
  factory TaskModel.fromJson(Map<String, dynamic>json) =>_$TaskModelFromJson(json);
}