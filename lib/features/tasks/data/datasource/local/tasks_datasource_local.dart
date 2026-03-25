import 'package:taskflowapp/features/tasks/data/model/task_model/task_model.dart';

abstract interface class TasksDatasourceLocal {
  Future<TaskModel?> getTaskById(String taskId);

  Future<List<TaskModel>?> listUserTasks ({
        String? searchKey,
  String? status,
  String sortBy = 'date',
  String sortOrder = 'desc',
  String? cursor,
  int limit = 10,
  String? categoryId
  });

  Future<void> addTaskToHive({required TaskModel task});

  Future<void> deleteTaskFromHive({required String taskId});
}