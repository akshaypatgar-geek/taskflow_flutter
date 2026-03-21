import 'package:taskflowapp/features/categories/data/datasource/local/category_datasource_local.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/repository/local_category_repository_interface.dart';
import 'package:taskflowapp/features/categories/local/model/category_hive/category_hive.dart';


class LocalCategoryRepositoryAdapter implements LocalCategoryRepositoryInterface {
  LocalCategoryRepositoryAdapter(this._localDatasource);

  final CategoryDatasourceLocal _localDatasource;

  @override
  Future<List<CategoryEntity>> getCachedCategories() async {
    final list = await _localDatasource.getCategories();
    return list
        .map((h) => CategoryEntity(
              categoryId: h.categoryId,
              categoryName: h.categoryName,
            ))
        .toList();
  }

  @override
  Future<CategoryEntity?> getCachedCategory(String categoryId) async {
    final h = await _localDatasource.getCategory(categoryId);
    return h != null
        ? CategoryEntity(categoryId: h.categoryId, categoryName: h.categoryName)
        : null;
  }

  @override
  Future<void> saveCategories(List<CategoryEntity> categories) async {
    final map = {
      for (final e in categories) e.categoryId: CategoryHive(categoryId: e.categoryId, categoryName: e.categoryName),
    };
    await _localDatasource.saveCategories(map);
  }

  @override
  Future<void> saveCategory(CategoryEntity category) async {
    await _localDatasource.saveCategory(
      CategoryHive(categoryId: category.categoryId, categoryName: category.categoryName),
    );
  }
}
