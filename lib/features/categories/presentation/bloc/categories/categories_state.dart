part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

class CategoriesFetchSuccessState extends CategoriesState {}

class CategoriesFailedState extends CategoriesState {

}

class CategoriesLoading extends CategoriesState {}
