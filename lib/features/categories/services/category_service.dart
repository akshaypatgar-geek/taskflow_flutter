import 'package:hive_ce/hive_ce.dart';

import '../data/model/category/category.dart';
import '../data/repository/category_repository.dart';
import '../local/model/category_hive/category_hive.dart';

class CategoryService {
  CategoryService({required this.repository});

  final CategoryRepository repository;

  /// In-memory cache to avoid repeated API calls for the same category (e.g. on rebuild).
  final Map<String, Category> _categoryCache = {};

  Future<List<Category>?> listCategories() async {
    List<CategoryHive> cachedCategories = Hive.box<CategoryHive>('categories').values.toList();
    final result = await repository.getCategories();
    
   return result.fold((l) {
      if(cachedCategories.isNotEmpty) return cachedCategories.map((e)=>Category(categoryId: e.categoryId, categoryName: e.categoryName)).toList();
      return null;
    } , (r) {
      
      return r.categories;
      },);
  }

  Future<Category?> getCategoryDetails({required String categoryId}) async {
    if (_categoryCache.containsKey(categoryId)) {
      return _categoryCache[categoryId];
    }
    final cachedCategory = Hive.box<CategoryHive>('categories').get(categoryId);
    final result = await repository.getCategoryDetails(categoryid: categoryId);
    return result.fold(
      (l) {
        if (cachedCategory != null) {
          final c = Category(
            categoryId: cachedCategory.categoryId,
            categoryName: cachedCategory.categoryName,
          );
          _categoryCache[categoryId] = c;
          return c;
        }
        return null;
      },
      (r) {
        _categoryCache[categoryId] = r;
        return r;
      },
    );
  }
}