import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/tasks/domain/repository/task_repository_interface.dart';

import '../entities/task_entity/task_entity.dart';

/// Updates a task. On network failure (offline), updates local cache with PENDING sync and returns local entity.
class UpdateTaskUseCase {
  UpdateTaskUseCase(this._repository, );

  final TaskRepositoryInterface _repository;

  Future<Either<Failure, TaskEntity>> call({
    required String taskId,
    String? title,
    String? priority,
    String? status,
  }) async {
    final result = await _repository.updateTask(
      id: taskId,
      title: title,
      priority: priority,
      status: status,
    );

    return result.fold(
      (failure) async {
        if (failure is! NetworkFailure) return Left(failure);
         return Left(failure);
      },
      (r) => right(r),
      
    );
  }
}
