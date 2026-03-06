
import 'dart:developer';

import '../data/model/category/category.dart';
import '../data/repository/category_repository.dart';

class CategoryService {
  final CategoryRepository repository;

  CategoryService({required this.repository});

  Future<List<Category>?> listCategories() async {
    final result = await repository.getCategories();
    log("response :$result");
   return result.fold((l) {
      log("error side");
      return null;
    } , (r) {
      log("got categories ${r.categories.length}");
      return r.categories;
      },);
  }
}