import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/tasks/domain/entities/list_tasks_result.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_stream_event.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/delete_task_locally_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/get_cached_filtered_tasks_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/list_user_tasks_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/save_task_locally_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/watch_task_updates_use_case.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/tasks/tasks_bloc.dart';

class MockGetCachedFilteredTasksUseCase extends Mock implements GetCachedFilteredTasksUseCase {}
class MockListUserTasksUseCase extends Mock implements ListUserTasksUseCase {}
class MockSaveTaskLocallyUseCase extends Mock implements SaveTaskLocallyUseCase {}
class MockDeleteTaskLocallyUseCase extends Mock implements DeleteTaskLocallyUseCase {}
class MockWatchTaskUpdatesUseCase extends Mock implements WatchTaskUpdatesUseCase {}

void main() {
  late TasksBloc tasksBloc;
  late MockGetCachedFilteredTasksUseCase mockGetCachedFilteredTasksUseCase;
  late MockListUserTasksUseCase mockListUserTasksUseCase;
  late MockSaveTaskLocallyUseCase mockSaveTaskLocallyUseCase;
  late MockDeleteTaskLocallyUseCase mockDeleteTaskLocallyUseCase;
  late MockWatchTaskUpdatesUseCase mockWatchTaskUpdatesUseCase;
  late StreamController<TaskStreamEvent> streamController;

  final testTask1 = TaskEntity(
    taskId: '1',
    title: 'Task 1',
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
    authorId: 'user1',
  );
  final testTask2 = TaskEntity(
    taskId: '2',
    title: 'Task 2',
    createdAt: DateTime(2025, 1, 2),
    updatedAt: DateTime(2025, 1, 2),
    authorId: 'user1',
  );

  setUp(() {
    mockGetCachedFilteredTasksUseCase = MockGetCachedFilteredTasksUseCase();
    mockListUserTasksUseCase = MockListUserTasksUseCase();
    mockSaveTaskLocallyUseCase = MockSaveTaskLocallyUseCase();
    mockDeleteTaskLocallyUseCase = MockDeleteTaskLocallyUseCase();
    mockWatchTaskUpdatesUseCase = MockWatchTaskUpdatesUseCase();
    streamController = StreamController<TaskStreamEvent>.broadcast();

    when(() => mockWatchTaskUpdatesUseCase())
        .thenAnswer((_) => streamController.stream);
    when(() => mockSaveTaskLocallyUseCase(any())).thenAnswer((_) async => {});
    when(() => mockDeleteTaskLocallyUseCase(any())).thenAnswer((_) async => {});

    tasksBloc = TasksBloc(
      getCachedFilteredTasksUseCase: mockGetCachedFilteredTasksUseCase,
      listUserTasksUseCase: mockListUserTasksUseCase,
      saveTaskLocallyUseCase: mockSaveTaskLocallyUseCase,
      deleteTaskLocallyUseCase: mockDeleteTaskLocallyUseCase,
      watchTaskUpdatesUseCase: mockWatchTaskUpdatesUseCase,
    );
  });

  tearDown(() {
    tasksBloc.close();
    streamController.close();
  });

  group('TasksBloc', () {
    blocTest<TasksBloc, TasksState>(
      'emits [TasksLoading, TasksListingSuccess] when ListUserTasks succeeds with no cache',
      build: () {
        when(() => mockGetCachedFilteredTasksUseCase(
              categoryId: any(named: 'categoryId'),
              searchKey: any(named: 'searchKey'),
              sortBy: any(named: 'sortBy'),
              sortOrder: any(named: 'sortOrder'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => []);
        when(() => mockListUserTasksUseCase(
              categoryId: any(named: 'categoryId'),
              searchKey: any(named: 'searchKey'),
              sortBy: any(named: 'sortBy'),
              sortOrder: any(named: 'sortOrder'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => Right(ListTasksResult(
                  tasks: [testTask1, testTask2],
                  nextCursor: null,
                  hasNextPage: false,
                )));
        return tasksBloc;
      },
      act: (bloc) => bloc.add(ListUserTasks()),
      expect: () => [
        TasksLoading(),
        TasksListingSuccess(tasks: [testTask1, testTask2], hasMore: false),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emits [TasksLoading, TasksListingSuccess (cached), TasksListingSuccess (fresh)] when cache exists then API succeeds',
      build: () {
        when(() => mockGetCachedFilteredTasksUseCase(
              categoryId: any(named: 'categoryId'),
              searchKey: any(named: 'searchKey'),
              sortBy: any(named: 'sortBy'),
              sortOrder: any(named: 'sortOrder'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => [testTask1]);
        when(() => mockListUserTasksUseCase(
              categoryId: any(named: 'categoryId'),
              searchKey: any(named: 'searchKey'),
              sortBy: any(named: 'sortBy'),
              sortOrder: any(named: 'sortOrder'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => Right(ListTasksResult(
                  tasks: [testTask1, testTask2],
                  nextCursor: null,
                  hasNextPage: false,
                )));
        return tasksBloc;
      },
      act: (bloc) => bloc.add(ListUserTasks()),
      expect: () => [
        TasksLoading(),
        TasksListingSuccess(tasks: [testTask1]),
        TasksListingSuccess(tasks: [testTask1, testTask2], hasMore: false),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emits [TasksLoading, TasksFailedState] when ListUserTasks fails with no cache and non-retryable',
      build: () {
        when(() => mockGetCachedFilteredTasksUseCase(
              categoryId: any(named: 'categoryId'),
              searchKey: any(named: 'searchKey'),
              sortBy: any(named: 'sortBy'),
              sortOrder: any(named: 'sortOrder'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => []);
        when(() => mockListUserTasksUseCase(
              categoryId: any(named: 'categoryId'),
              searchKey: any(named: 'searchKey'),
              sortBy: any(named: 'sortBy'),
              sortOrder: any(named: 'sortOrder'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => const Left(ServerFailure('Server error')));
        return tasksBloc;
      },
      act: (bloc) => bloc.add(ListUserTasks()),
      expect: () => [
        TasksLoading(),
        TasksFailedState(errorMessage: 'Server error'),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emits [TasksLoading, TasksListingSuccess (cached)] when ListUserTasks fails with cache (retryable)',
      build: () {
        when(() => mockGetCachedFilteredTasksUseCase(
              categoryId: any(named: 'categoryId'),
              searchKey: any(named: 'searchKey'),
              sortBy: any(named: 'sortBy'),
              sortOrder: any(named: 'sortOrder'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => [testTask1]);
        when(() => mockListUserTasksUseCase(
              categoryId: any(named: 'categoryId'),
              searchKey: any(named: 'searchKey'),
              sortBy: any(named: 'sortBy'),
              sortOrder: any(named: 'sortOrder'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => const Left(NetworkFailure()));
        return tasksBloc;
      },
      act: (bloc) => bloc.add(ListUserTasks()),
      expect: () => [
        TasksLoading(),
        TasksListingSuccess(tasks: [testTask1]),
        TasksListingSuccess(tasks: [testTask1]),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emits [TasksListingSuccess] with task removed when RemoveTaskFromList is dispatched',
      build: () => tasksBloc,
      seed: () => TasksListingSuccess(tasks: [testTask1, testTask2]),
      act: (bloc) => bloc.add(RemoveTaskFromList(taskId: '1')),
      expect: () => [
        TasksListingSuccess(tasks: [testTask2]),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emits [TasksListingSuccess] with new task when AddTaskToList is dispatched',
      build: () => tasksBloc,
      seed: () => TasksListingSuccess(tasks: [testTask1]),
      act: (bloc) => bloc.add(AddTaskToList(task: testTask2)),
      expect: () => [
        TasksListingSuccess(tasks: [testTask2, testTask1]),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emits [TasksListingSuccess] with updated task when UpdateOneTask is dispatched',
      build: () => tasksBloc,
      seed: () => TasksListingSuccess(tasks: [testTask1, testTask2]),
      act: (bloc) => bloc.add(UpdateOneTask(task: testTask1.copyWith(title: 'Updated'))),
      expect: () => [
        TasksListingSuccess(tasks: [testTask1.copyWith(title: 'Updated'), testTask2]),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emits [TasksListingSuccess] with new task when TaskCreatedEvent is received via stream',
      build: () => tasksBloc,
      seed: () => TasksListingSuccess(tasks: [testTask1]),
      act: (bloc) => streamController.add(TaskCreatedEvent(testTask2)),
      expect: () => [
        TasksListingSuccess(tasks: [testTask2, testTask1]),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emits [TasksListingSuccess] with task removed when TaskDeletedEvent is received via stream',
      build: () => tasksBloc,
      seed: () => TasksListingSuccess(tasks: [testTask1, testTask2]),
      act: (bloc) => streamController.add(TaskDeletedEvent('1')),
      expect: () => [
        TasksListingSuccess(tasks: [testTask2]),
      ],
    );

    blocTest<TasksBloc, TasksState>(
      'emits [TasksListingSuccess] with updated task when TaskUpdatedEvent is received via stream',
      build: () => tasksBloc,
      seed: () => TasksListingSuccess(tasks: [testTask1, testTask2]),
      act: (bloc) => streamController.add(TaskUpdatedEvent(testTask1.copyWith(title: 'Updated'))),
      expect: () => [
        TasksListingSuccess(tasks: [testTask1.copyWith(title: 'Updated'), testTask2]),
      ],
    );
  });
}
