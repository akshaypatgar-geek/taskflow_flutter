import 'package:taskflowapp/features/tasks/data/model/delete_task_response/delete_task_response.dart';
import 'package:taskflowapp/features/tasks/data/model/task_model/task_model.dart';

/// Remote data source for single-task operations (get, create, update, delete).
/// Throws [AppException] on failure.
abstract interface class TaskDatasourceRemote {
  Future<TaskModel> getTaskDetails({required String taskId});

  Future<TaskModel> createTask({
    required String taskTitle,
    String? priority,
    String? categoryId,
    required String id,
  });

  Future<TaskModel> updateTask({
    required String id,
    String? priority,
    String? status,
    String? title,
  });

  Future<DeleteTaskResponse> deleteTask({required String taskId});
}
