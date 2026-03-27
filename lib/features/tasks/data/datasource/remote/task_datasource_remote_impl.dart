import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/core/network/exceptions.dart';
import 'package:taskflowapp/features/tasks/data/model/delete_task_response/delete_task_response.dart';
import 'package:taskflowapp/features/tasks/data/model/task_model/task_model.dart';
import 'package:taskflowapp/features/tasks/data/datasource/remote/task_datasource_remote.dart';

class TaskDatasourceRemoteImpl implements TaskDatasourceRemote {
  TaskDatasourceRemoteImpl({required this.client});

  final DioClient client;

  @override
  Future<TaskModel> getTaskDetails({required String taskId}) async {
    final response = await client.getRequest<Map<String, dynamic>>(
      endpoint: EndPoints.taskDetails(taskId),
    );
    if (response == null) throw const ServerException('No response');
    return TaskModel.fromJson(response);
  }

  @override
  Future<TaskModel> createTask({
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
    final response = await client.postRequest<Map<String, dynamic>>(
      endpoint: EndPoints.createTask,
      body: body,
    );
    if (response == null) throw ServerException('No response');
    return TaskModel.fromJson(response);
  }

  @override
  Future<TaskModel> updateTask({
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
    final response = await client.patchRequest<Map<String, dynamic>>(
      endpoint: EndPoints.updateTask,
      body: body,
    );
    if (response == null) throw ServerException('No response');
    return TaskModel.fromJson(response);
  }

  @override
  Future<DeleteTaskResponse> deleteTask({required String taskId}) async {
    final response = await client.deleteRequest<Map<String, dynamic>>(
      endpoint: EndPoints.deleteTask(taskId),
    );
    if (response == null) throw ServerException('No response');
    return DeleteTaskResponse.fromJson(response);
  }
}
