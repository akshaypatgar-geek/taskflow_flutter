import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/features/categories/data/model/list_categories_response/list_categories_response.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/network/exceptions.dart';
import '../../../../core/network/failures.dart';

class CategoryRepository {
  final DioClient client;

  CategoryRepository({required this.client});

  Future<Either<Failure, ListCategoriesResponse>> getCategories() async {
    try {
      final resposne = await client.getRequest(endpoint: EndPoints.listCategories);
      log("all categories :$resposne");
      final responseDTO = ListCategoriesResponse.fromJson(resposne);
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
}