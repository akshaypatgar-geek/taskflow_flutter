import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';

abstract interface class CategoryRepositoryInterface {
  Future<Either<Failure, List<CategoryEntity>>> listCategories();

  Future<Either<Failure, CategoryEntity>> getCategoryDetails({
    required String categoryId,
  });

  Future<Either<Failure, CategoryEntity>> createCategory({
    required String title,
  });
}
