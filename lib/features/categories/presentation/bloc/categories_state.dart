part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  CategoriesLoaded({required this.categories});

  final List<CategoryEntity> categories;
}

class CategoriesCreating extends CategoriesState {
  CategoriesCreating({required this.categories});

  final List<CategoryEntity> categories;
}

class CategoriesFailed extends CategoriesState {
  CategoriesFailed({required this.errorMessage, this.categories});

  final String errorMessage;
  final List<CategoryEntity>? categories;
}
