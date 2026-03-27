import 'package:taskflowapp/features/tasks/data/model/list_tasks_response/list_tasks_response.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/exceptions.dart';
import '../../../../../core/utils/constants.dart';
import 'tasks_datasource_remote.dart';

class TasksDatasourceRemoteImpl implements TasksDatasourceRemote{
  final DioClient client;

  TasksDatasourceRemoteImpl({required this.client});
  @override
  Future<ListTasksResponse> listUserTasks({
    String? searchKey,
    String? status,
    String sortBy = TaskLiterals.sortByDate,
    String sortOrder = TaskLiterals.sortOrderDesc,
    String? cursor,
    int limit = TaskDefaults.pageSize,
    String? categoryId,
  }) async{
    final Map<String, dynamic> queryParams = {};
    if(searchKey !=null && searchKey !='') {
      queryParams[TaskQueryKeys.searchKey] = searchKey;
    }
    if(status !=null && status != TaskLiterals.statusAll) {
      queryParams[TaskQueryKeys.status] = status;
    }
    if(cursor != null) {
      queryParams[TaskQueryKeys.cursor] = cursor;
    }
    if(categoryId !=null) {
      queryParams[TaskQueryKeys.categoryId] = categoryId;
    }
      queryParams[TaskQueryKeys.sortBy] = sortBy;
      queryParams[TaskQueryKeys.sortOrder] = sortOrder;
      queryParams[TaskQueryKeys.limit] = limit;
    final result = await client.getRequest<Map<String, dynamic>>(
      endpoint: EndPoints.listTasks,
      queryParams: queryParams,
    );
    if (result == null) {
      throw const ServerException(AppStrings.somethingWrongTryAgainLater);
    }
    return ListTasksResponse.fromJson(result);
  }
}