
import 'dart:developer';

import 'package:hive_ce/hive_ce.dart';

import '../data/model/category/category.dart';
import '../data/repository/category_repository.dart';
import '../local/model/category_hive/category_hive.dart';

class CategoryService {
  final CategoryRepository repository;

  CategoryService({required this.repository});

  Future<List<Category>?> listCategories() async {
    List<CategoryHive> cachedCategories = Hive.box<CategoryHive>('categories').values.toList();
    final result = await repository.getCategories();
    log("response :$result");
   return result.fold((l) {
      if(cachedCategories.isNotEmpty) return cachedCategories.map((e)=>Category(categoryId: e.categoryId, categoryName: e.categoryName)).toList();
      return null;
    } , (r) {
      log("got categories ${r.categories.length}");
      return r.categories;
      },);
  }

  Future<Category?> getCategoryDetails({required String categoryId}) async {
    final cachedCategory = Hive.box<CategoryHive>('categories').get(categoryId);
    final result = await repository.getCategoryDetails(categoryid: categoryId);
    return result.fold((l) {
      if(cachedCategory !=null) return Category(categoryId: cachedCategory.categoryId, categoryName: cachedCategory.categoryName);
      return null;
    }, (r) => r,);
  }
}