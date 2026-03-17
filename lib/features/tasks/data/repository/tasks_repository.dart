import 'package:dartz/dartz.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:taskflowapp/features/tasks/local/model/task_hive/task_hive.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/exception_to_failure.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failures.dart';
import '../model/list_tasks_response/list_tasks_response.dart';

class TasksRepository {
  final DioClient client;

  TasksRepository({required this.client});
  Future<Either<Failure, ListTasksResponse>> listUserTasks({
    String? searchKey,
  String? status,
  String sortBy = 'date',
  String sortOrder = 'desc',
  String? cursor,
  int limit = 10,
  String? categoryId
  }
  ) async {
    Map<String, dynamic> queryParams = {};
    if(searchKey !=null && searchKey !="") {
      queryParams['searchKey'] = searchKey;
    }
    if(status !=null && status !="all") {
      queryParams['status'] = status;
    }
    if(cursor != null) {
      queryParams['cursor'] = cursor;
    }
    if(categoryId !=null) {
      queryParams['categoryId'] = categoryId;
    }
      queryParams['sortBy'] = sortBy;
      queryParams['sortOrder'] = sortOrder;
      queryParams['limit'] = limit;
    try {
      final result = await client.getRequest<Map<String, dynamic>>(
        endpoint: EndPoints.listTasks,
        queryParams: queryParams,
      );
      final tasksDTO = ListTasksResponse.fromJson(result!);
      final tasksBox = Hive.box<TaskHive>('tasks');
      
      final Map<String, TaskHive> obj = {for(var t in tasksDTO.tasks) t.taskId : TaskHive(taskId: t.taskId, title: t.title, createdAt: t.createdAt, authorId: t.authorId, categoryId: t.categoryId, priority: t.priority, status: t.status.name, updatedAt: t.updatedAt,syncStatus: t.syncStatus.name)};
      tasksBox.putAll(obj);
      return Right(tasksDTO);
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    }
  }
}