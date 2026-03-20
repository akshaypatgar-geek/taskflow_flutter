import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/features/categories/data/datasource/local/category_datasource_local.dart';
import 'package:taskflowapp/features/categories/local/model/category_hive/category_hive.dart';

class CategoryDatasourceLocalImpl implements CategoryDatasourceLocal {
  CategoryDatasourceLocalImpl({required this.categoryBox});

  final Box<CategoryHive> categoryBox;

  @override
  Future<List<CategoryHive>> getCategories() async {
    return categoryBox.values.toList();
  }

  @override
  Future<CategoryHive?> getCategory(String categoryId) async {
    return categoryBox.get(categoryId);
  }

  @override
  Future<void> saveCategories(Map<String, CategoryHive> categories) async {
    final localKeys = categoryBox.keys.cast<String>().toList();
    final serverKeys = categories.keys.toSet();
    for (final key in localKeys) {
      if (!serverKeys.contains(key)) {
        categoryBox.delete(key);
      }
    }
    await categoryBox.putAll(categories);
  }

  @override
  Future<void> saveCategory(CategoryHive category) async {
    await categoryBox.put(category.categoryId, category);
  }
}
