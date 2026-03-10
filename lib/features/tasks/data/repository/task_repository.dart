import 'dart:developer';

import 'package:dartz/dartz.dart' hide Task;
import 'package:taskflowapp/features/tasks/data/model/delete_task_response/delete_task_response.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failures.dart';
import '../model/task/task.dart';

class TaskRepository {
  final DioClient client;

  TaskRepository({required this.client});
  Future<Either<Failure, Task>>
  getTaskDetails({required String taskId}) async {
    try {
      final response = await client.getRequest(endpoint: EndPoints.taskDetails(taskId),
      );
      log("details:$response");
      final taskDTO = Task.fromJson(response);
      return Right(taskDTO);
    }on NetworkException catch(e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch(e) {
      return Left(NotFoundFailure(e.message));
    } on ExistsException catch(e) {
      return Left(ExistsFailure(e.message));
    } on UnauthorizedException catch(e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<Either<Failure, Task>> createTask({required String taskTitle, String? priority, String? categoryId}) async {
    try {
      final response = await client.postRequest(endpoint: EndPoints.createTask,body: {
        "title":taskTitle,
    "priority":priority,
    "categoryId": categoryId
      });
      final responseDTO = Task.fromJson(response);
      return Right(responseDTO);
    }on NetworkException catch(e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch(e) {
      return Left(NotFoundFailure(e.message));
    } on ExistsException catch(e) {
      return Left(ExistsFailure(e.message));
    } on UnauthorizedException catch(e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<Either<Failure, Task>> updateTask({required String id, String? priority, String? status, String? title}) async {
    try {
      final response = await client.patchRequest(endpoint: EndPoints.updateTask,body: {
        "id":id,
        "title":title,
    "priority":priority,
    "status": status
      });
      final responseDTO = Task.fromJson(response);
      return Right(responseDTO);
    }on NetworkException catch(e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch(e) {
      return Left(NotFoundFailure(e.message));
    } on ExistsException catch(e) {
      return Left(ExistsFailure(e.message));
    } on UnauthorizedException catch(e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<Either<Failure, DeleteTaskResponse>> deleteTask({required String taskId}) async {
    try {
      final response = await client.deleteRequest(endpoint: EndPoints.deleteTask(taskId));
      final resposneDTO = DeleteTaskResponse.fromJson(response);
      return Right(resposneDTO);
    }on NetworkException catch(e) {
      return Left(NetworkFailure(e.message));
    } on NotFoundException catch(e) {
      return Left(NotFoundFailure(e.message));
    } on ExistsException catch(e) {
      return Left(ExistsFailure(e.message));
    } on UnauthorizedException catch(e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch(e) {
      return Left(ServerFailure(e.message));
    }
  }
}