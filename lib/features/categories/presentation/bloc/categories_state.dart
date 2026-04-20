part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState extends Equatable{
  const CategoriesState();

  @override
  List<Object?> get props => [];
}

final class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
 const CategoriesLoaded({required this.categories});

  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => [categories];
}

class CategoriesCreating extends CategoriesState {
 const CategoriesCreating({required this.categories});

  final List<CategoryEntity> categories;

  @override
  List<Object?> get props => [categories];
}

class CategoriesFailed extends CategoriesState {
 const CategoriesFailed({required this.errorMessage, this.categories});

  final String errorMessage;
  final List<CategoryEntity>? categories;

  @override
  List<Object?> get props => [errorMessage, categories];
}
