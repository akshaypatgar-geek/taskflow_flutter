import 'package:taskflowapp/features/tasks/domain/repository/local_tasks_repository_interface.dart';

/// Removes a task from local cache by id.
class DeleteTaskLocallyUseCase {
  DeleteTaskLocallyUseCase(this._localRepo);

  final LocalTasksRepositoryInterface _localRepo;

  Future<void> call(String taskId) => _localRepo.deleteTask(taskId);
}
