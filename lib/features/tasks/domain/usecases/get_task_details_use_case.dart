import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/repository/local_tasks_repository_interface.dart';
import 'package:taskflowapp/features/tasks/domain/repository/task_repository_interface.dart';

import '../entities/task_entity/task_entity.dart';

/// Fetches task details (cache first optional; then API). Returns domain entity.
class GetTaskDetailsUseCase {
  GetTaskDetailsUseCase(this._repository);

  final TaskRepositoryInterface _repository;

  Future<Either<Failure, TaskEntity>> call(String taskId) async {
    
    final result = await _repository.getTaskDetails(taskId: taskId);
    return result.fold(
      (failure) =>  Left(failure),
      (r) => right(r),
      
    );
  }
}
