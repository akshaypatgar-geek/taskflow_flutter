import 'package:taskflowapp/core/utils/enums.dart';
import 'package:taskflowapp/features/tasks/data/model/task_model/task_model.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';

/// Maps between data-layer [TaskModel] and domain [TaskEntity].
class TaskEntityMapper {
  static TaskEntity toEntity(TaskModel model) {
    return TaskEntity(
      taskId: model.taskId,
      title: model.title,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      authorId: model.authorId,
      priority: model.priority,
      categoryId: model.categoryId,
      status: model.status,
      syncStatus: model.syncStatus,
    );
  }

  static TaskModel toModel(TaskEntity entity) {
    return TaskModel(
      taskId: entity.taskId,
      title: entity.title,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      authorId: entity.authorId,
      priority: entity.priority,
      categoryId: entity.categoryId,
      status: entity.status ?? TaskStatusEnum.OPEN,
      syncStatus: entity.syncStatus ?? SyncStatus.SYNCED,
    );
  }
}
