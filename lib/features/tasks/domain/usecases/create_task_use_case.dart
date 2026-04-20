import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/core/utils/enums.dart';
import 'package:taskflowapp/features/tasks/domain/repository/task_repository_interface.dart';

import '../entities/task_entity/task_entity.dart';

/// Creates a task. On network failure (offline), saves locally with PENDING sync and returns the local entity.
class CreateTaskUseCase {
  CreateTaskUseCase(this._repository);

  final TaskRepositoryInterface _repository;

  Future<Either<Failure, TaskEntity>> call({
    required String taskId,
    required String title,
    String? priority,
    String? categoryId,
    required String authorId,
  }) async {
    if (title.trim().isEmpty) {
      return const Left(ServerFailure('Title cannot be empty'));
    }

    final result = await _repository.createTask(
      taskTitle: title.trim(),
      priority: priority,
      categoryId: categoryId,
      id: taskId,
    );

    return result.fold((failure) async {
      if (failure is! NetworkFailure) return Left(failure);
      final localEntity = TaskEntity(
        taskId: taskId,
        title: title.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        authorId: authorId,
        priority: priority ?? 'LOW',
        categoryId: categoryId,
        syncStatus: SyncStatus.PENDING,
      );
      return Right(localEntity);
    }, Right.new);
  }
}
