import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/exception_to_failure.dart';
import 'package:taskflowapp/core/network/exceptions.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/features/tasks/data/datasource/local/tasks_datasource_local.dart';
import 'package:taskflowapp/features/tasks/data/datasource/remote/tasks_datasource_remote.dart';
import 'package:taskflowapp/features/tasks/data/mapper/task_entity_mapper.dart';
import 'package:taskflowapp/features/tasks/domain/entities/list_tasks_result.dart';
import 'package:taskflowapp/features/tasks/domain/repository/tasks_repository_interface.dart';

class TasksRepositoryImpl implements TasksRepository {
  TasksRepositoryImpl({
    required TasksDatasourceLocal localDatasource,
    required TasksDatasourceRemote remoteDataSource,
  })  : _localDatasource = localDatasource,
        _remoteDataSource = remoteDataSource;

  final TasksDatasourceLocal _localDatasource;
  final TasksDatasourceRemote _remoteDataSource;

  @override
  Future<Either<Failure, ListTasksResult>> listUserTasks({
    String? searchKey,
    String? status,
    String sortBy = 'date',
    String sortOrder = 'desc',
    String? cursor,
    int limit = TaskDefaults.pageSize,
    String? categoryId,
  }) async {
    try {
      final response = await _remoteDataSource.listUserTasks(
        searchKey: searchKey,
        categoryId: categoryId,
        cursor: cursor,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
        status: status,
      );
      for (final task in response.tasks) {
        await _localDatasource.addTaskToHive(task: task);
      }
      final result = ListTasksResult(
        tasks: response.tasks.map(TaskEntityMapper.toEntity).toList(),
        hasNextPage: response.hasNextPage,
        nextCursor: response.nextCursor,
      );
      return right(result);
    } on AppException catch (e) {
      final cached = await _localDatasource.listUserTasks(
        searchKey: searchKey,
        status: status,
        sortBy: sortBy,
        sortOrder: sortOrder,
        limit: limit,
        categoryId: categoryId,
      );
      if (cached != null && cached.isNotEmpty) {
        return right(ListTasksResult(
          tasks: cached.map(TaskEntityMapper.toEntity).toList(),
          hasNextPage: false,
          nextCursor: null,
        ));
      }
      return left(exceptionToFailure(e));
    }
  }
}
