import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/end_points.dart';
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
      log("query :$queryParams");
      final result = await client.getRequest(endpoint: EndPoints.listTasks,
      queryParams: queryParams);
      log("rsponse :$result");
      final tasksDTO = ListTasksResponse.fromJson(result);
      log("length:${tasksDTO.tasks} ${tasksDTO.nextCursor}");
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
  
}