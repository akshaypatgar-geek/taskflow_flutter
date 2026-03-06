import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:taskflowapp/features/tasks/data/model/task_mutation_response/task_mutation_response.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/end_points.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failures.dart';
import '../model/get_task_details_response/get_task_details_response.dart';
import '../model/list_tasks_response/list_tasks_response.dart';

class TasksRepository {
  final DioClient client;

  TasksRepository({required this.client});
  Future<Either<Failure, ListTasksResponse>> listUserTasks() async {
    try {
      final result = await client.getRequest(endpoint: EndPoints.listTasks);
      final tasksDTO = ListTasksResponse.fromJson(result);
      return Right(tasksDTO);
    } on NetworkException catch(e) {
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

  // Future<Either<Failure, TaskMutationResponse>> createTask({required String taskTitle, String? priority, String? categoryId}) async {
  //   try {
  //     final response = await client.postRequest(endpoint: EndPoints.createTask,body: {
  //       "title":taskTitle,
  //   "priority":priority,
  //   "categoryId": categoryId
  //     });
  //     final responseDTO = TaskMutationResponse.fromJson(response);
  //     return Right(responseDTO);
  //   }on NetworkException catch(e) {
  //     return Left(NetworkFailure(e.message));
  //   } on NotFoundException catch(e) {
  //     return Left(NotFoundFailure(e.message));
  //   } on ExistsException catch(e) {
  //     return Left(ExistsFailure(e.message));
  //   } on UnauthorizedException catch(e) {
  //     return Left(UnauthorizedFailure(e.message));
  //   } on ServerException catch(e) {
  //     return Left(ServerFailure(e.message));
  //   }
  // }
  
}