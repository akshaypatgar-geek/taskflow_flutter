import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/usecases/create_category_use_case.dart';
import 'package:taskflowapp/features/categories/domain/usecases/get_cached_categories_use_case.dart';
import 'package:taskflowapp/features/categories/domain/usecases/list_categories_use_case.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  CategoriesBloc({
    required this.getCachedCategoriesUseCase,
    required this.listCategoriesUseCase,
    required this.createCategoryUseCase,
  }) : super(CategoriesInitial()) {
    on<LoadCategories>(_loadCategories);
    on<CreateCategory>(_createCategory);
  }

  final GetCachedCategoriesUseCase getCachedCategoriesUseCase;
  final ListCategoriesUseCase listCategoriesUseCase;
  final CreateCategoryUseCase createCategoryUseCase;

  Future<void> _loadCategories(
    LoadCategories event,
    Emitter<CategoriesState> emit,
  ) async {
    emit(CategoriesLoading());
    final cachedCategories = await getCachedCategoriesUseCase();
    if (cachedCategories.isNotEmpty) {
      emit(CategoriesLoaded(categories: cachedCategories));
    }

    final result = await listCategoriesUseCase();
    result.fold(
      (l) {
        if (cachedCategories.isNotEmpty) {
          emit(CategoriesLoaded(categories: cachedCategories));
        } else {
          emit(CategoriesFailed(errorMessage: l.message));
        }
      },
      (r) => emit(CategoriesLoaded(categories: r)),
    );
  }

  Future<void> _createCategory(
    CreateCategory event,
    Emitter<CategoriesState> emit,
  ) async {
    final previousCategories = state is CategoriesLoaded
        ? (state as CategoriesLoaded).categories
        : <CategoryEntity>[];
    if (previousCategories.isNotEmpty) {
      emit(CategoriesCreating(categories: previousCategories));
    } else {
      emit(CategoriesLoading());
    }
    final result = await createCategoryUseCase(title: event.title);
    result.fold(
      (l) => emit(CategoriesFailed(
        errorMessage: l.message,
        categories: previousCategories.isNotEmpty ? previousCategories : null,
      )),
      (r) => emit(CategoriesLoaded(categories: [...previousCategories, r])),
    );
  }
}
