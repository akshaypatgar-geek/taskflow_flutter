
import 'package:dartz/dartz.dart' hide Task;
import 'package:taskflowapp/core/offline/offline_request.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
import 'package:taskflowapp/features/tasks/data/model/delete_task_response/delete_task_response.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/exception_to_failure.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failures.dart';
import '../model/task/task.dart';

class TaskRepository {
  final DioClient client;
  final OfflineRequestRepository offlineRequestRepository;

  TaskRepository({required this.client, required this.offlineRequestRepository});
  Future<Either<Failure, Task>>
  getTaskDetails({required String taskId}) async {
    try {
      final response = await client.getRequest<Map<String, dynamic>>(endpoint: EndPoints.taskDetails(taskId));
      final taskDTO = Task.fromJson(response!);
      return Right(taskDTO);
    } on AppException catch (e) {
      return Left(exceptionToFailure(e));
    }
  }

  Future<Either<Failure, Task>> createTask({required String taskTitle, String? priority, String? categoryId, required String id}) async {
    Map<String, dynamic> body = {
      "id": id,
        "title":taskTitle,
    "priority":priority,
    "categoryId": categoryId
      };
    try {
      final response = await client.postRequest<Map<String, dynamic>>(endpoint: EndPoints.createTask, body: body);
      final responseDTO = Task.fromJson(response!);
      return Right(responseDTO);
    } on AppException catch (e) {
      if (e is NetworkException) {
        await offlineRequestRepository.addNewRequest(OfflineRequest(method: 'POST', endpoint: EndPoints.createTask, body: body));
      }
      return Left(exceptionToFailure(e));
    }
  }

  Future<Either<Failure, Task>> updateTask({required String id, String? priority, String? status, String? title}) async {
    Map<String, dynamic> body = {
        "id":id,
        "title":title,
    "priority":priority,
    "status": status
      };
    try {
      final response = await client.patchRequest<Map<String, dynamic>>(endpoint: EndPoints.updateTask, body: body);
      final responseDTO = Task.fromJson(response!);
      return Right(responseDTO);
    } on AppException catch (e) {
      if (e is NetworkException) {
        await offlineRequestRepository.addNewRequest(OfflineRequest(method: 'PATCH', endpoint: EndPoints.updateTask, body: body));
      }
      return Left(exceptionToFailure(e));
    }
  }

  Future<Either<Failure, DeleteTaskResponse>> deleteTask({required String taskId}) async {
    try {
      final response = await client.deleteRequest<Map<String, dynamic>>(endpoint: EndPoints.deleteTask(taskId));
      final resposneDTO = DeleteTaskResponse.fromJson(response!);
      return Right(resposneDTO);
    } on AppException catch (e) {
      if (e is NetworkException) {
        await offlineRequestRepository.addNewRequest(OfflineRequest(method: 'DELETE', endpoint: EndPoints.deleteTask(taskId)));
      }
      return Left(exceptionToFailure(e));
    }
  }
}