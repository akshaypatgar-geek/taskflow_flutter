part of 'categories_bloc.dart';

sealed class CategoriesEvent {}

class LoadCategories extends CategoriesEvent {}

class CreateCategory extends CategoriesEvent {
  CreateCategory({required this.title});

  final String title;
}
