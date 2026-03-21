import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';

import '../entities/task_entity/task_entity.dart';

/// Contract for single-task operations (get, create, update, delete).
abstract class TaskRepositoryInterface {
  Future<Either<Failure, TaskEntity>> getTaskDetails({required String taskId});

  Future<Either<Failure, TaskEntity>> createTask({
    required String taskTitle,
    String? priority,
    String? categoryId,
    required String id,
  });

  Future<Either<Failure, TaskEntity>> updateTask({
    required String id,
    String? priority,
    String? status,
    String? title,
  });

  Future<Either<Failure, String>> deleteTask({required String taskId});
}
