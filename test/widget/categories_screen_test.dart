import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/features/categories/domain/entities/category_entity.dart';
import 'package:taskflowapp/features/categories/domain/usecases/create_category_use_case.dart';
import 'package:taskflowapp/features/categories/domain/usecases/get_cached_categories_use_case.dart';
import 'package:taskflowapp/features/categories/domain/usecases/list_categories_use_case.dart';
import 'package:taskflowapp/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:taskflowapp/features/categories/presentation/screen/categories_screen.dart';

import '../helpers/widget_test_helpers.dart';

class MockGetCachedCategoriesUseCase extends Mock
    implements GetCachedCategoriesUseCase {}

class MockListCategoriesUseCase extends Mock implements ListCategoriesUseCase {}

class MockCreateCategoryUseCase extends Mock implements CreateCategoryUseCase {}

void main() {
  late CategoriesBloc categoriesBloc;
  late MockGetCachedCategoriesUseCase mockGetCached;
  late MockListCategoriesUseCase mockList;

  setUp(() {
    mockGetCached = MockGetCachedCategoriesUseCase();
    mockList = MockListCategoriesUseCase();
    categoriesBloc = CategoriesBloc(
      getCachedCategoriesUseCase: mockGetCached,
      listCategoriesUseCase: mockList,
      createCategoryUseCase: MockCreateCategoryUseCase(),
    );
  });

  tearDown(() => categoriesBloc.close());

  group('CategoriesScreen', () {
    testWidgets('renders Categories title and loading initially', (
      tester,
    ) async {
      when(() => mockGetCached()).thenAnswer((_) async => []);
      when(() => mockList()).thenAnswer((_) async => const Right([]));

      await pumpTestWidget(
        tester,
        const CategoriesScreen(),
        categoriesBloc: categoriesBloc,
      );
      categoriesBloc.add(LoadCategories());
      await tester.pump();

      expect(find.text('Categories'), findsOneWidget);
    });

    testWidgets('shows category list when loaded', (tester) async {
      final categories = [
        const CategoryEntity(categoryId: '1', categoryName: 'Work'),
        const CategoryEntity(categoryId: '2', categoryName: 'Personal'),
      ];
      when(() => mockGetCached()).thenAnswer((_) async => []);
      when(() => mockList()).thenAnswer((_) async => Right(categories));

      await pumpTestWidget(
        tester,
        const CategoriesScreen(),
        categoriesBloc: categoriesBloc,
      );
      categoriesBloc.add(LoadCategories());
      await tester.pumpAndSettle();

      expect(find.text('Work'), findsOneWidget);
      expect(find.text('Personal'), findsOneWidget);
    });

    testWidgets('shows empty state when no categories', (tester) async {
      when(() => mockGetCached()).thenAnswer((_) async => []);
      when(() => mockList()).thenAnswer((_) async => const Right([]));

      await pumpTestWidget(
        tester,
        const CategoriesScreen(),
        categoriesBloc: categoriesBloc,
      );
      categoriesBloc.add(LoadCategories());
      await tester.pumpAndSettle();

      expect(
        find.text('No categories yet. Tap + to create one.'),
        findsOneWidget,
      );
    });

    testWidgets('has create category FAB with semantic label', (tester) async {
      when(() => mockGetCached()).thenAnswer((_) async => []);
      when(() => mockList()).thenAnswer((_) async => const Right([]));

      await pumpTestWidget(
        tester,
        const CategoriesScreen(),
        categoriesBloc: categoriesBloc,
      );
      categoriesBloc.add(LoadCategories());
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Create category'), findsOneWidget);
    });
  });
}
