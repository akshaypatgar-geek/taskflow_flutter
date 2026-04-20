import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/exception_to_failure.dart';
import 'package:taskflowapp/core/network/exceptions.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/core/offline/offline_request.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/core/utils/enums.dart';
import 'package:taskflowapp/features/tasks/data/datasource/local/tasks_datasource_local.dart';
import 'package:taskflowapp/features/tasks/data/datasource/remote/task_datasource_remote.dart';
import 'package:taskflowapp/features/tasks/data/mapper/task_entity_mapper.dart';
import 'package:taskflowapp/features/tasks/data/model/task_model/task_model.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/repository/task_repository_interface.dart';
import 'package:taskflowapp/core/offline/service/background_sync_service.dart';

/// Task CRUD repository with offline support. Queues mutations via
/// [OfflineRequestRepository] when the device is offline, and caches
/// results locally through [TasksDatasourceLocal].
class TaskRepositoryImpl implements TaskRepositoryInterface {
  TaskRepositoryImpl({
    required TaskDatasourceRemote remoteDatasource,
    required TasksDatasourceLocal localDatasource,
    required OfflineRequestRepository offlineRequestRepository,
  })  : _remoteDatasource = remoteDatasource,
        _localDatasource = localDatasource,
        _offlineRequestRepository = offlineRequestRepository;

  final TaskDatasourceRemote _remoteDatasource;
  final TasksDatasourceLocal _localDatasource;
  final OfflineRequestRepository _offlineRequestRepository;

  /// Fetches a single task by [taskId]. Falls back to Hive cache on failure.
  @override
  Future<Either<Failure, TaskEntity>> getTaskDetails({required String taskId}) async {
    try {
      final model = await _remoteDatasource.getTaskDetails(taskId: taskId);
      await _localDatasource.addTaskToHive(task: model);
      return Right(TaskEntityMapper.toEntity(model));
    } on AppException catch (e) {
      final cached = await _localDatasource.getTaskById(taskId);
      if (cached != null) {
        return Right(TaskEntityMapper.toEntity(cached));
      }
      return Left(exceptionToFailure(e));
    }
  }

  /// Creates a task. Queues the request offline if a [NetworkException] is thrown.
  @override
  Future<Either<Failure, TaskEntity>> createTask({
    required String taskTitle,
    String? priority,
    String? categoryId,
    required String id,
  }) async {
    final body = {
      'id': id,
      'title': taskTitle,
      'priority': priority,
      'categoryId': categoryId,
    };
    try {
      final model = await _remoteDatasource.createTask(
        taskTitle: taskTitle,
        priority: priority,
        categoryId: categoryId,
        id: id,
      );
      await _localDatasource.addTaskToHive(task: model);
      return Right(TaskEntityMapper.toEntity(model));
    } on AppException catch (e) {
      if (e is NetworkException) {
        await _offlineRequestRepository.addNewRequest(
          OfflineRequest(method: 'POST', endpoint: EndPoints.createTask, body: body),
        );
        BackgroundSyncService.runOnce();
      }
      return Left(exceptionToFailure(e));
    }
  }

  /// Updates a task and syncs Hive. Queues offline on network failure.
  @override
  Future<Either<Failure, TaskEntity>> updateTask({
    required String id,
    String? priority,
    String? status,
    String? title,
  }) async {
    final body = {
      'id': id,
      'title': title,
      'priority': priority,
      'status': status,
    };
    try {
      final model = await _remoteDatasource.updateTask(
        id: id,
        priority: priority,
        status: status,
        title: title,
      );
      await _localDatasource.addTaskToHive(task: model);
      return Right(TaskEntityMapper.toEntity(model));
    } on AppException catch (e) {
      if (e is NetworkException) {
        await _offlineRequestRepository.addNewRequest(
          OfflineRequest(method: 'PATCH', endpoint: EndPoints.updateTask, body: body),
        );
        BackgroundSyncService.runOnce();
        final existing = await _localDatasource.getTaskById(id);
        if (existing != null) {
          final statusEnum = status != null
              ? TaskStatusEnum.values.firstWhere(
                  (s) => s.name == status,
                  orElse: () => existing.status,
                )
              : existing.status;
          final merged = TaskModel(
            taskId: id,
            title: title ?? existing.title,
            createdAt: existing.createdAt,
            updatedAt: DateTime.now(),
            authorId: existing.authorId,
            priority: priority ?? existing.priority,
            categoryId: existing.categoryId,
            status: statusEnum,
            syncStatus: SyncStatus.PENDING,
          );
          await _localDatasource.addTaskToHive(task: merged);
          return Right(TaskEntityMapper.toEntity(merged));
        }
      }
      return Left(exceptionToFailure(e));
    }
  }

  /// Deletes a task by [taskId] and removes it from Hive.
  @override
  Future<Either<Failure, String>> deleteTask({required String taskId}) async {
    try {
      final response = await _remoteDatasource.deleteTask(taskId: taskId);
      await _localDatasource.deleteTaskFromHive(taskId: taskId);
      return Right(response.taskId);
    } on AppException catch (e) {
      if (e is NetworkException) {
        await _offlineRequestRepository.addNewRequest(
          OfflineRequest(method: 'DELETE', endpoint: EndPoints.deleteTask(taskId)),
        );
        BackgroundSyncService.runOnce();
      }
      return Left(exceptionToFailure(e));
    }
  }
}
