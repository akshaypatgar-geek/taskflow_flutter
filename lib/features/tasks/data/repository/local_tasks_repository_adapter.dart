import 'package:taskflowapp/features/tasks/data/datasource/local/tasks_datasource_local.dart';
import 'package:taskflowapp/features/tasks/data/mapper/task_entity_mapper.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/repository/local_tasks_repository_interface.dart';


class LocalTasksRepositoryAdapter implements LocalTasksRepositoryInterface {
  LocalTasksRepositoryAdapter(this._localDatasource);

  final TasksDatasourceLocal _localDatasource;

  @override
  Future<void> saveTask(TaskEntity task) =>
      _localDatasource.addTaskToHive(task: TaskEntityMapper.toModel(task));

  @override
  Future<void> deleteTask(String taskId) =>
      _localDatasource.deelteTaskFromHIve(taskId: taskId);

  @override
  Future<List<TaskEntity>> getFilteredTasks({
    String? searchKey,
    String? sortBy,
    String? sortOrder,
    String? status,
    String? categoryId,
  }) async {
    final list = await _localDatasource.listUserTasks(
      searchKey: searchKey,
      sortBy: sortBy ?? 'date',
      sortOrder: sortOrder ?? 'desc',
      status: status,
      categoryId: categoryId,
    );
    if (list == null) return [];
    return list.map(TaskEntityMapper.toEntity).toList();
  }
}