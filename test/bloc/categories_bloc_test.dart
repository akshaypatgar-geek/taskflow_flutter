import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/usecases/create_category_use_case.dart';
import 'package:taskflowapp/features/categories/domain/usecases/get_cached_categories_use_case.dart';
import 'package:taskflowapp/features/categories/domain/usecases/list_categories_use_case.dart';
import 'package:taskflowapp/features/categories/presentation/bloc/categories_bloc.dart';

class MockGetCachedCategoriesUseCase extends Mock implements GetCachedCategoriesUseCase {}
class MockListCategoriesUseCase extends Mock implements ListCategoriesUseCase {}
class MockCreateCategoryUseCase extends Mock implements CreateCategoryUseCase {}

void main() {
  late CategoriesBloc categoriesBloc;
  late MockGetCachedCategoriesUseCase mockGetCachedCategoriesUseCase;
  late MockListCategoriesUseCase mockListCategoriesUseCase;
  late MockCreateCategoryUseCase mockCreateCategoryUseCase;

  final testCategories = [
    CategoryEntity(categoryId: '1', categoryName: 'Work'),
    CategoryEntity(categoryId: '2', categoryName: 'Personal'),
  ];

  setUp(() {
    mockGetCachedCategoriesUseCase = MockGetCachedCategoriesUseCase();
    mockListCategoriesUseCase = MockListCategoriesUseCase();
    mockCreateCategoryUseCase = MockCreateCategoryUseCase();

    categoriesBloc = CategoriesBloc(
      getCachedCategoriesUseCase: mockGetCachedCategoriesUseCase,
      listCategoriesUseCase: mockListCategoriesUseCase,
      createCategoryUseCase: mockCreateCategoryUseCase,
    );
  });

  tearDown(() => categoriesBloc.close());

  group('CategoriesBloc', () {
    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesLoaded] when LoadCategories succeeds with no cache',
      build: () {
        when(() => mockGetCachedCategoriesUseCase()).thenAnswer((_) async => []);
        when(() => mockListCategoriesUseCase())
            .thenAnswer((_) async => Right(testCategories));
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(LoadCategories()),
      expect: () => [
        CategoriesLoading(),
        CategoriesLoaded(categories: testCategories),
      ],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesLoaded (cached), CategoriesLoaded (fresh)] when cache exists then API succeeds',
      build: () {
        when(() => mockGetCachedCategoriesUseCase())
            .thenAnswer((_) async => [testCategories.first]);
        when(() => mockListCategoriesUseCase())
            .thenAnswer((_) async => Right(testCategories));
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(LoadCategories()),
      expect: () => [
        CategoriesLoading(),
        CategoriesLoaded(categories: [testCategories.first]),
        CategoriesLoaded(categories: testCategories),
      ],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesFailed] when LoadCategories fails with no cache',
      build: () {
        when(() => mockGetCachedCategoriesUseCase()).thenAnswer((_) async => []);
        when(() => mockListCategoriesUseCase())
            .thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(LoadCategories()),
      expect: () => [
        CategoriesLoading(),
        CategoriesFailed(errorMessage: 'Server error'),
      ],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesLoaded (cached)] when LoadCategories fails but cache exists',
      build: () {
        when(() => mockGetCachedCategoriesUseCase())
            .thenAnswer((_) async => testCategories);
        when(() => mockListCategoriesUseCase())
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(LoadCategories()),
      expect: () => [
        CategoriesLoading(),
        CategoriesLoaded(categories: testCategories),
        CategoriesLoaded(categories: testCategories),
      ],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesCreating, CategoriesLoaded] when CreateCategory succeeds with existing categories',
      build: () {
        when(() => mockGetCachedCategoriesUseCase()).thenAnswer((_) async => []);
        when(() => mockListCategoriesUseCase())
            .thenAnswer((_) async => Right(testCategories));
        when(() => mockCreateCategoryUseCase(title: any(named: 'title')))
            .thenAnswer((_) async => Right(CategoryEntity(categoryId: '3', categoryName: 'New')));
        return categoriesBloc;
      },
      seed: () => CategoriesLoaded(categories: testCategories),
      act: (bloc) => bloc.add(CreateCategory(title: 'New')),
      expect: () => [
        CategoriesCreating(categories: testCategories),
        CategoriesLoaded(categories: [...testCategories, CategoryEntity(categoryId: '3', categoryName: 'New')]),
      ],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesLoading, CategoriesLoaded] when CreateCategory succeeds with no previous categories',
      build: () {
        when(() => mockCreateCategoryUseCase(title: any(named: 'title')))
            .thenAnswer((_) async => Right(CategoryEntity(categoryId: '1', categoryName: 'First')));
        return categoriesBloc;
      },
      act: (bloc) => bloc.add(CreateCategory(title: 'First')),
      expect: () => [
        CategoriesLoading(),
        CategoriesLoaded(categories: [CategoryEntity(categoryId: '1', categoryName: 'First')]),
      ],
    );

    blocTest<CategoriesBloc, CategoriesState>(
      'emits [CategoriesCreating, CategoriesFailed] when CreateCategory fails',
      build: () {
        when(() => mockCreateCategoryUseCase(title: any(named: 'title')))
            .thenAnswer((_) async => const Left(ServerFailure('Create failed')));
        return categoriesBloc;
      },
      seed: () => CategoriesLoaded(categories: testCategories),
      act: (bloc) => bloc.add(CreateCategory(title: 'New')),
      expect: () => [
        CategoriesCreating(categories: testCategories),
        CategoriesFailed(
          errorMessage: 'Create failed',
          categories: testCategories,
        ),
      ],
    );
  });
}
