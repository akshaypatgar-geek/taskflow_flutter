import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_stream_event.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/create_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/get_task_details_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/watch_task_updates_use_case.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';

class MockGetTaskDetailsUseCase extends Mock implements GetTaskDetailsUseCase {}
class MockCreateTaskUseCase extends Mock implements CreateTaskUseCase {}
class MockUpdateTaskUseCase extends Mock implements UpdateTaskUseCase {}
class MockDeleteTaskUseCase extends Mock implements DeleteTaskUseCase {}
class MockWatchTaskUpdatesUseCase extends Mock implements WatchTaskUpdatesUseCase {}

void main() {
  late TaskBloc taskBloc;
  late MockGetTaskDetailsUseCase mockGetTaskDetailsUseCase;
  late MockCreateTaskUseCase mockCreateTaskUseCase;
  late MockUpdateTaskUseCase mockUpdateTaskUseCase;
  late MockDeleteTaskUseCase mockDeleteTaskUseCase;
  late MockWatchTaskUpdatesUseCase mockWatchTaskUpdatesUseCase;
  late StreamController<TaskStreamEvent> streamController;

  final testTask = TaskEntity(
    taskId: '1',
    title: 'Test Task',
    createdAt: DateTime(2025, 1, 1),
    updatedAt: DateTime(2025, 1, 1),
    authorId: '123',
    priority: 'HIGH',
    categoryId: 'cat1',
  );

  setUp(() {
    mockGetTaskDetailsUseCase = MockGetTaskDetailsUseCase();
    mockCreateTaskUseCase = MockCreateTaskUseCase();
    mockUpdateTaskUseCase = MockUpdateTaskUseCase();
    mockDeleteTaskUseCase = MockDeleteTaskUseCase();
    mockWatchTaskUpdatesUseCase = MockWatchTaskUpdatesUseCase();
    streamController = StreamController<TaskStreamEvent>.broadcast();

    when(() => mockWatchTaskUpdatesUseCase())
        .thenAnswer((_) => streamController.stream);

    taskBloc = TaskBloc(
      getTaskDetailsUseCase: mockGetTaskDetailsUseCase,
      createTaskUseCase: mockCreateTaskUseCase,
      updateTaskUseCase: mockUpdateTaskUseCase,
      deleteTaskUseCase: mockDeleteTaskUseCase,
      watchTaskUpdatesUseCase: mockWatchTaskUpdatesUseCase,
    );
  });

  tearDown(() {
    taskBloc.close();
    streamController.close();
  });

  group('TaskBloc', () {
    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskDetailsSuccess] when GetTaskDetails is successful',
      build: () {
        when(() => mockGetTaskDetailsUseCase(any()))
            .thenAnswer((_) async => Right(testTask));
        return taskBloc;
      },
      act: (bloc) => bloc.add(GetTaskDetails(taskId: '1')),
      expect: () => [
        TaskLoading(),
        TaskDetailsSuccess(task: testTask),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskFailedState] when GetTaskDetails fails',
      build: () {
        when(() => mockGetTaskDetailsUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure('Not found')));
        return taskBloc;
      },
      act: (bloc) => bloc.add(GetTaskDetails(taskId: '1')),
      expect: () => [
        TaskLoading(),
        TaskFailedState(errorMessage: 'Not found'),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskCreationSuccess] when CreateTaskEvent is successful',
      build: () {
        when(() => mockCreateTaskUseCase(
              taskId: any(named: 'taskId'),
              title: any(named: 'title'),
              priority: any(named: 'priority'),
              categoryId: any(named: 'categoryId'),
              authorId: any(named: 'authorId'),
            )).thenAnswer((_) async => Right(testTask));
        return taskBloc;
      },
      act: (bloc) => bloc.add(CreateTaskEvent(
        taskId: '1',
        title: 'Test Task',
        priority: 'HIGH',
        categoryId: 'cat1',
      )),
      expect: () => [
        TaskLoading(),
        TaskCreationSuccess(task: testTask),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskFailedState] when CreateTaskEvent fails',
      build: () {
        when(() => mockCreateTaskUseCase(
              taskId: any(named: 'taskId'),
              title: any(named: 'title'),
              priority: any(named: 'priority'),
              categoryId: any(named: 'categoryId'),
              authorId: any(named: 'authorId'),
            )).thenAnswer((_) async => const Left(ServerFailure('Create failed')));
        return taskBloc;
      },
      act: (bloc) => bloc.add(CreateTaskEvent(
        taskId: '1',
        title: 'Test Task',
        priority: 'HIGH',
        categoryId: 'cat1',
      )),
      expect: () => [
        TaskLoading(),
        TaskFailedState(errorMessage: 'Create failed'),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskUpdateSuccess] when UpdateTaskEvent is successful',
      build: () {
        when(() => mockUpdateTaskUseCase(
              taskId: any(named: 'taskId'),
              title: any(named: 'title'),
              priority: any(named: 'priority'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => Right(testTask));
        return taskBloc;
      },
      act: (bloc) => bloc.add(UpdateTaskEvent(
        taskId: '1',
        title: 'Updated',
        priority: 'HIGH',
        status: 'Completed',
      )),
      expect: () => [
        TaskLoading(),
        TaskUpdateSuccess(task: testTask),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskDeletionSuccess] when DeleteTask is successful',
      build: () {
        when(() => mockDeleteTaskUseCase(any()))
            .thenAnswer((_) async => const Right('1'));
        return taskBloc;
      },
      act: (bloc) => bloc.add(DeleteTask(taskId: '1')),
      expect: () => [
        TaskLoading(),
        TaskDeletionSuccess(taskId: '1'),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskDetailsSuccess] when WebSocket TaskUpdatedEvent is received',
      build: () => taskBloc,
      act: (bloc) => streamController.add(TaskUpdatedEvent(testTask)),
      expect: () => [
        TaskDetailsSuccess(task: testTask),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskDeletionSuccess] when WebSocket TaskDeletedEvent is received',
      build: () => taskBloc,
      act: (bloc) => streamController.add(TaskDeletedEvent('1')),
      expect: () => [
        TaskDeletionSuccess(taskId: '1'),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskDetailsSuccess] when UpdateToExistingTask is dispatched',
      build: () => taskBloc,
      act: (bloc) => bloc.add(UpdateToExistingTask(task: testTask)),
      expect: () => [
        TaskDetailsSuccess(task: testTask),
      ],
    );
  });
}
