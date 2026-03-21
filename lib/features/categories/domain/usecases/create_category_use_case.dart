import 'package:dartz/dartz.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/repository/category_repository_interface.dart';

class CreateCategoryUseCase {
  CreateCategoryUseCase(this._repository);

  final CategoryRepositoryInterface _repository;

  Future<Either<Failure, CategoryEntity>> call({required String title}) =>
      _repository.createCategory(title: title);
}
