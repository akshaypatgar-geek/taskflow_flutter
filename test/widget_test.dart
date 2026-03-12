import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:taskflowapp/core/utils/enums.dart';
import 'package:taskflowapp/features/tasks/data/model/delete_task_response/delete_task_response.dart';
import 'package:taskflowapp/features/tasks/data/model/task/task.dart';
import 'package:taskflowapp/features/tasks/data/repository/task_repository.dart';
import 'package:taskflowapp/features/tasks/presentation/bloc/task/task_bloc.dart';
import 'package:taskflowapp/services/websocket/socket_service.dart';


// Mocks
class MockTaskRepository extends Mock implements TaskRepository {}
class MockSocketService extends Mock implements SocketService {}

void main() {
  late TaskBloc taskBloc;
  late MockTaskRepository mockRepository;
  late MockSocketService mockSocketService;
  late StreamController<Map<String, dynamic>> socketStreamController;

  // setUp(() {
  //   mockRepository = MockTaskRepository();
  //   socketStreamController = StreamController<Map<String, dynamic>>();
  //   mockSocketService = MockSocketService();

  //   taskBloc = TaskBloc(
  //     repository: mockRepository,
  //     socketService: mockSocketService
  //   );

  //   // Assign mocked stream to public taskSub
  //   taskBloc.taskSub = socketStreamController.stream.listen((event) {});
  // });

  setUp(() {
  mockRepository = MockTaskRepository();
  mockSocketService = MockSocketService();

  // 1️⃣ Create a controlled stream
  socketStreamController = StreamController<Map<String, dynamic>>();

  // 2️⃣ Mock the taskUpdates getter to return the stream
  when(() => mockSocketService.taskUpdates)
      .thenAnswer((_) => socketStreamController.stream);

  // 3️⃣ Now create the bloc
  taskBloc = TaskBloc(
    repository: mockRepository,
    socketService: mockSocketService,
  );
});

  tearDown(() {
    taskBloc.close();
    socketStreamController.close();
  });

  // Fully populated test task
  final testTask = Task(
    taskId: "1",
    title: 'Test Task',
    priority: 'HIGH',
    status: TaskStatusEnum.OPEN,
    categoryId: "1",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    authorId: "123",
  );

  group('TaskBloc', () {
    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskDetailsSuccess] when GetTaskDetails is successful',
      build: () {
        when(() => mockRepository.getTaskDetails(taskId: "1"))
            .thenAnswer((_) async => Right(testTask));
        return taskBloc;
      },
      act: (bloc) => bloc.add(GetTaskDetails(taskId: "1")),
      expect: () => [
        TaskLoading(),
        TaskDetailsSuccess(task: testTask),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskCreationSuccess] when CreateTaskEvent is successful',
      build: () {
        when(() => mockRepository.createTask(
              taskTitle: any(named: 'taskTitle'),
              priority: any(named: 'priority'),
              categoryId: any(named: 'categoryId'),
            )).thenAnswer((_) async => Right(testTask));
        return taskBloc;
      },
      act: (bloc) => bloc.add(
        CreateTaskEvent(title: 'Test Task', priority: 'HIGH', categoryId: "1"),
      ),
      expect: () => [
        TaskLoading(),
        TaskCreationSuccess(task: testTask),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskUpdateSuccess] when UpdateTaskEvent is successful',
      build: () {
        when(() => mockRepository.updateTask(
              id: "1",
              title: any(named: 'title'),
              priority: any(named: 'priority'),
              status: any(named: 'status'),
            )).thenAnswer((_) async => Right(testTask));
        return taskBloc;
      },
      act: (bloc) => bloc.add(
        UpdateTaskEvent(
          taskId: "1",
          title: 'Updated',
          priority: 'HIGH',
          status: 'Completed',
        ),
      ),
      expect: () => [
        TaskLoading(),
        TaskUpdateSuccess(task: testTask),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskDeletionSuccess] when DeleteTask is successful',
      build: () {
        when(() => mockRepository.deleteTask(taskId: "1"))
            .thenAnswer((_) async => Right(DeleteTaskResponse(taskId: "1")));
        return taskBloc;
      },
      act: (bloc) => bloc.add(DeleteTask(taskId: "1")),
      expect: () => [
        TaskLoading(),
        TaskDeletionSuccess(taskId: "1"),
      ],
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskDetailsSuccess] when WebSocket UPDATE event is received',
      build: () => taskBloc,
      act: (bloc) => socketStreamController.add({
        'event': 'UPDATE',
        'data': testTask.toJson(),
      }),
      expect: () => [
        TaskDetailsSuccess(task: testTask),
      ],
    );
blocTest<TaskBloc, TaskState>(
  'emits [TaskLoading, TaskDeletionSuccess] when DeleteTask is successful',
  build: () {
    when(() => mockRepository.deleteTask(taskId: "1"))
        .thenAnswer((_) async => Right(DeleteTaskResponse(taskId: "1")));
    return taskBloc;
  },
  act: (bloc) => bloc.add(DeleteTask(taskId: "1")),
  expect: () => [
    TaskLoading(),
    TaskDeletionSuccess(taskId: "1"),
  ],
);
  });
}