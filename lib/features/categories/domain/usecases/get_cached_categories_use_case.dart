import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/repository/local_category_repository_interface.dart';

class GetCachedCategoriesUseCase {
  GetCachedCategoriesUseCase(this._localRepo);

  final LocalCategoryRepositoryInterface _localRepo;

  Future<List<CategoryEntity>> call() => _localRepo.getCachedCategories();
}
