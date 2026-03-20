import 'package:taskflowapp/features/tasks/data/model/list_tasks_response/list_tasks_response.dart';

import '../../../../../core/network/dio_client.dart';
import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/exceptions.dart';
import 'tasks_datasource_remote.dart';

class TasksDatasourceRemoteImpl implements TasksDatasourceRemote{
  final DioClient client;

  TasksDatasourceRemoteImpl({required this.client});
  @override
  Future<ListTasksResponse> listUserTasks({String? searchKey, String? status, String sortBy = 'date', String sortOrder = 'desc', String? cursor, int limit = 10, String? categoryId,}) async{
    final Map<String, dynamic> queryParams = {};
    if(searchKey !=null && searchKey !='') {
      queryParams['searchKey'] = searchKey;
    }
    if(status !=null && status !='all') {
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
      return tasksDTO;
    } on AppException catch (_) {
      rethrow;
    }
  }
}