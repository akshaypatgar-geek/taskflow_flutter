import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/tasks/domain/entities/list_tasks_result.dart';

/// Contract for listing user tasks with filters and pagination.
abstract interface class TasksRepository {
  Future<Either<Failure, ListTasksResult>> listUserTasks({
    String? searchKey,
    String? status,
    String sortBy = 'date',
    String sortOrder = 'desc',
    String? cursor,
    int limit = 10,
    String? categoryId,
  });
}
