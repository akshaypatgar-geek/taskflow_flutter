import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/features/categories/presentation/bloc/categories_bloc.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/create_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/delete_task_locally_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/get_cached_filtered_tasks_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/get_task_details_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/list_user_tasks_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/save_task_locally_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/watch_task_updates_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';
import 'package:taskflowapp/features/tasks/presentation/screen/task_form_screen.dart';

import '../helpers/widget_test_helpers.dart';
import 'categories_screen_test.dart';

class MockGetTaskDetailsUseCase extends Mock implements GetTaskDetailsUseCase {}
class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}
class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}
class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}
class MockWatchTaskUpdatesUseCase extends Mock implements WatchTaskUpdatesUseCase {}
class MockGetCachedFilteredTasksUseCase extends Mock implements GetCachedFilteredTasksUseCase {}
class MockListUserTasksUseCase extends Mock implements ListUserTasksUseCase {}
class MockSaveTaskLocallyUseCase extends Mock implements SaveTaskLocallyUseCase {}
class MockDeleteTaskLocallyUseCase extends Mock implements DeleteTaskLocallyUseCase {}

void main() {
  late TaskBloc taskBloc;
  late TasksBloc tasksBloc;
  late MockGetCachedCategoriesUseCase mockGetCachedCategories;
  late MockListCategoriesUseCase mockListCategories;
  late MockWatchTaskUpdatesUseCase mockWatchTaskUpdates;
  late CategoriesBloc categoriesBloc;

  setUp(() {
    mockGetCachedCategories = MockGetCachedCategoriesUseCase();
    mockListCategories = MockListCategoriesUseCase();
    mockWatchTaskUpdates = MockWatchTaskUpdatesUseCase();
    when(() => mockGetCachedCategories()).thenAnswer((_) async => []);
    when(() => mockListCategories()).thenAnswer((_) async => const Right([]));
    when(() => mockWatchTaskUpdates()).thenAnswer((_) => Stream.empty());
    categoriesBloc = CategoriesBloc(
      getCachedCategoriesUseCase: mockGetCachedCategories,
      listCategoriesUseCase: mockListCategories,
      createCategoryUseCase: MockCreateCategoryUseCase(),
    );

    taskBloc = TaskBloc(
      getTaskDetailsUseCase: MockGetTaskDetailsUseCase(),
      createTaskUseCase: MockCreateTaskUseCase(),
      updateTaskUseCase: MockUpdateTaskUseCase(),
      deleteTaskUseCase: MockDeleteTaskUseCase(),
      watchTaskUpdatesUseCase: mockWatchTaskUpdates,
    );
    tasksBloc = TasksBloc(
      getCachedFilteredTasksUseCase: MockGetCachedFilteredTasksUseCase(),
      listUserTasksUseCase: MockListUserTasksUseCase(),
      saveTaskLocallyUseCase: MockSaveTaskLocallyUseCase(),
      deleteTaskLocallyUseCase: MockDeleteTaskLocallyUseCase(),
      watchTaskUpdatesUseCase: mockWatchTaskUpdates,
    );
  });

  tearDown(() {
    taskBloc.close();
    tasksBloc.close();
    categoriesBloc.close();
  });

  group('TaskFormWidget - Create', () {
    testWidgets('renders Create Task title and form fields', (tester) async {
      await pumpTestWidget(
        tester,
        const TaskFormWidget(task: null),
        taskBloc: taskBloc,
        tasksBloc: tasksBloc,
        categoriesBloc: categoriesBloc,
      );
      categoriesBloc.add(LoadCategories());
      await tester.pumpAndSettle();

      expect(find.text('Create Task'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
    });
  });

  group('TaskFormWidget - Edit', () {
    testWidgets('renders Update Task title when editing', (tester) async {
      final task = TaskEntity(
        taskId: '1',
        title: 'Existing Task',
        createdAt: DateTime(2025, 1, 1),
        updatedAt: DateTime(2025, 1, 1),
        authorId: 'user1',
      );

      await pumpTestWidget(
        tester,
        TaskFormWidget(task: task),
        taskBloc: taskBloc,
        tasksBloc: tasksBloc,
        categoriesBloc: categoriesBloc,
      );
      await tester.pumpAndSettle();

      expect(find.text('Update Task'), findsOneWidget);
    });
  });
}
