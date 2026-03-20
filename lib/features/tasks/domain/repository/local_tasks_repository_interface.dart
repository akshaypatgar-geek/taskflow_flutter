import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';

/// Contract for local task storage (cache / offline).
abstract interface class LocalTasksRepositoryInterface {
  Future<void> saveTask(TaskEntity task);

  Future<void> deleteTask(String taskId);

  Future<List<TaskEntity>> getFilteredTasks({
    String? searchKey,
    String? sortBy,
    String? sortOrder,
    String? status,
    String? categoryId,
  });
}
