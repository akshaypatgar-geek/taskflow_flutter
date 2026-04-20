import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/features/tasks/domain/entities/list_tasks_result.dart';
import 'package:taskflowapp/features/tasks/domain/repository/tasks_repository_interface.dart';

class ListUserTasksUseCase {
  final TasksRepository _repository;

  ListUserTasksUseCase({required TasksRepository repository}) : _repository = repository;

  Future<Either<Failure, ListTasksResult>> call({
    String? searchKey,
    String? status,
    String sortBy = 'date',
    String sortOrder = 'desc',
    String? cursor,
    int limit = TaskDefaults.pageSize,
    String? categoryId,
  }) async {
    final result = await _repository.listUserTasks(
      searchKey: searchKey,
      status: status,
      sortBy: sortBy,
      sortOrder: sortOrder,
      cursor: cursor,
      limit: limit,
      categoryId: categoryId,
    );

    return result.fold(
      Left.new,
      (listResult) async {
        return Right(ListTasksResult(
          tasks: listResult.tasks,
          nextCursor: listResult.nextCursor,
          hasNextPage: listResult.hasNextPage,
        ));
      },
    );
  }
}
