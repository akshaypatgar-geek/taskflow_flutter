import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';

/// Contract for local category storage (cache / offline).
abstract interface class LocalCategoryRepositoryInterface {
  Future<List<CategoryEntity>> getCachedCategories();

  Future<CategoryEntity?> getCachedCategory(String categoryId);

  Future<void> saveCategories(List<CategoryEntity> categories);

  Future<void> saveCategory(CategoryEntity category);
}
