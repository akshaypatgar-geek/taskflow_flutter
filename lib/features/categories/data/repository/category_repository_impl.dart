import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/end_points.dart';
import 'package:taskflowapp/core/network/exception_to_failure.dart';
import 'package:taskflowapp/core/network/exceptions.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/features/categories/data/model/category/category.dart';
import 'package:taskflowapp/features/categories/data/model/list_categories_response/list_categories_response.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/repository/category_repository_interface.dart';
import 'package:taskflowapp/features/categories/domain/repository/local_category_repository_interface.dart';

import '../../../../core/network/dio_client.dart';

class CategoryRepositoryImpl implements CategoryRepositoryInterface {
  CategoryRepositoryImpl(
    this._client, {
    required LocalCategoryRepositoryInterface localRepository,
  }) : _localRepository = localRepository;

  final DioClient _client;
  final LocalCategoryRepositoryInterface _localRepository;

  @override
  Future<Either<Failure, List<CategoryEntity>>> listCategories() async {
    try {
      final response = await _client.getRequest<Map<String, dynamic>>(
        endpoint: EndPoints.listCategories,
      );
      if(response == null) {
        throw const ServerException(AppStrings.somethingWrongTryAgainLater);
      }
      final dto = ListCategoriesResponse.fromJson(response);
      final entities = dto.categories
          .map((c) => CategoryEntity(categoryId: c.categoryId, categoryName: c.categoryName))
          .toList();
      await _localRepository.saveCategories(entities);
      return right(entities);
    } on AppException catch (e) {
      final cached = await _localRepository.getCachedCategories();
      if (cached.isNotEmpty) {
        return right(cached);
      }
      return left(exceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> getCategoryDetails({
    required String categoryId,
  }) async {
    try {
      final response = await _client.getRequest<Map<String, dynamic>>(
        endpoint: EndPoints.categoryDetails(categoryId),
      );
      if(response == null) {
        throw const ServerException(AppStrings.somethingWrongTryAgainLater);
      }
      final dto = Category.fromJson(response);
      final entity = CategoryEntity(
        categoryId: dto.categoryId,
        categoryName: dto.categoryName,
      );
      await _localRepository.saveCategory(entity);
      return right(entity);
    } on AppException catch (e) {
      final cached = await _localRepository.getCachedCategory(categoryId);
      if (cached != null) {
        return right(cached);
      }
      return left(exceptionToFailure(e));
    }
  }

  @override
  Future<Either<Failure, CategoryEntity>> createCategory({
    required String title,
  }) async {
    try {
      final response = await _client.postRequest<Map<String, dynamic>>(
        endpoint: EndPoints.createCategory,
        body: {'title': title},
      );
       if(response == null) {
        throw const ServerException(AppStrings.somethingWrongTryAgainLater);
      }
      final dto = Category.fromJson(response);
      final entity = CategoryEntity(
        categoryId: dto.categoryId,
        categoryName: dto.categoryName,
      );
      await _localRepository.saveCategory(entity);
      return right(entity);
    } on AppException catch (e) {
      return left(exceptionToFailure(e));
    }
  }
}
