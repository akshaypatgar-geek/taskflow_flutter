import 'package:taskflowapp/features/categories/local/model/category_hive/category_hive.dart';

/// Contract for local category storage (cache / offline).
abstract interface class CategoryDatasourceLocal {
  Future<List<CategoryHive>> getCategories();

  Future<CategoryHive?> getCategory(String categoryId);

  Future<void> saveCategories(Map<String, CategoryHive> categories);

  Future<void> saveCategory(CategoryHive category);
}
