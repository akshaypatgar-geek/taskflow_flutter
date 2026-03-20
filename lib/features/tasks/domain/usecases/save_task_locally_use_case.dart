import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/repository/local_tasks_repository_interface.dart';

/// Saves a single task to local cache (e.g. after create/update or WebSocket).
class SaveTaskLocallyUseCase {
  SaveTaskLocallyUseCase(this._localRepo);

  final LocalTasksRepositoryInterface _localRepo;

  Future<void> call(TaskEntity task) => _localRepo.saveTask(task);
}
