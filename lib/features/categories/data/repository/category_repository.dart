import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/features/categories/data/model/category/category.dart';
import 'package:taskflowapp/features/categories/data/model/list_categories_response/list_categories_response.dart';
import 'package:taskflowapp/features/categories/local/model/category_hive/category_hive.dart';

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
      final Box categoryBox =Hive.box<CategoryHive>('categories');
      final responseDTO = ListCategoriesResponse.fromJson(resposne);
      List<String> localCategories = categoryBox.keys.cast<String>() .toList();
      Set serverKeys = responseDTO.categories.map((e)=>e.categoryId).toSet();
      for( var key in localCategories) {
       if(! serverKeys.contains(key)){
        categoryBox.delete(key);
       }
      }
      final Map<String,CategoryHive> categories = { for (var e in responseDTO.categories) e.categoryId : CategoryHive(categoryId: e.categoryId, categoryName: e.categoryName) };
      await categoryBox.putAll(categories);
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

  Future<Either<Failure, Category>>getCategoryDetails({required String categoryid}) async {
    try {
      final response = await client.getRequest(endpoint: EndPoints.categoryDetails(categoryid));
      final resposneDTO = Category.fromJson(response);
      
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