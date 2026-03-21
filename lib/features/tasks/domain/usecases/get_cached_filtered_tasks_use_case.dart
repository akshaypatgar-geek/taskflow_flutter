import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/repository/local_tasks_repository_interface.dart';

/// Returns cached tasks filtered and sorted. Used for initial list and after local updates.
class GetCachedFilteredTasksUseCase {
  GetCachedFilteredTasksUseCase(this._localRepo);

  final LocalTasksRepositoryInterface _localRepo;

  Future<List<TaskEntity>> call({
    String? searchKey,
    String? status,
    String sortBy = 'date',
    String sortOrder = 'desc',
    String? categoryId,
  }) {
    return _localRepo.getFilteredTasks(
      searchKey: searchKey,
      sortBy: sortBy,
      sortOrder: sortOrder,
      status: status,
      categoryId: categoryId,
    );
  }
}
