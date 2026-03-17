import 'package:hive_ce/hive_ce.dart';

import '../data/model/category/category.dart';
import '../data/repository/category_repository.dart';
import '../local/model/category_hive/category_hive.dart';

class CategoryService {
  CategoryService({required this.repository});

  final CategoryRepository repository;

  /// In-memory cache to avoid repeated API calls for the same category (e.g. on rebuild).
  final Map<String, Category> _categoryCache = {};
  /// Same Future per categoryId so FutureBuilder on rebuild gets the same Future and does not refetch.
  final Map<String, Future<Category?>> _categoryFutureCache = {};

  /// Returns categories from API or from local cache when offline/error. Never throws.
  Future<List<Category>?> listCategories() async {
    final cachedCategories = Hive.box<CategoryHive>('categories').values.toList();
    try {
      final result = await repository.getCategories();
      return result.fold(
        (_) {
          if (cachedCategories.isNotEmpty) {
            return cachedCategories
                .map((e) => Category(categoryId: e.categoryId, categoryName: e.categoryName))
                .toList();
          }
          return null;
        },
        (r) => r.categories,
      );
    } catch (_) {
      // Offline or any unexpected error: return cache so UI doesn't crash.
      if (cachedCategories.isNotEmpty) {
        return cachedCategories
            .map((e) => Category(categoryId: e.categoryId, categoryName: e.categoryName))
            .toList();
      }
      return null;
    }
  }

  Future<Category?> getCategoryDetails({required String categoryId}) async {
    if (_categoryCache.containsKey(categoryId)) {
      return _categoryCache[categoryId];
    }
    if (_categoryFutureCache.containsKey(categoryId)) {
      return _categoryFutureCache[categoryId]!;
    }
    final future = _fetchAndCacheCategory(categoryId);
    _categoryFutureCache[categoryId] = future;
    return future;
  }

  Future<Category?> _fetchAndCacheCategory(String categoryId) async {
    try {
      final cachedCategory = Hive.box<CategoryHive>('categories').get(categoryId);
      final result = await repository.getCategoryDetails(categoryid: categoryId);
      final category = result.fold<Category?>(
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
      return category;
    } finally {
      _categoryFutureCache.remove(categoryId);
    }
  }
}