import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/tasks/domain/repository/local_tasks_repository_interface.dart';
import 'package:taskflowapp/features/tasks/domain/repository/task_repository_interface.dart';

/// Deletes a task. On network failure (offline), removes from local cache and returns taskId.
class DeleteTaskUseCase {
  DeleteTaskUseCase(this._repository,);

  final TaskRepositoryInterface _repository;

  Future<Either<Failure, String>> call(String taskId) async {
    final result = await _repository.deleteTask(taskId: taskId);

    return result.fold(
      (failure) async {
        if (failure is NetworkFailure) {
          return Right(taskId);
        }
        return Left(failure);
      },
      (id) => Future.value(Right(id)),
    );
  }
}
