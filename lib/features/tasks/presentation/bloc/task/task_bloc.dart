import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_stream_event.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/create_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/get_task_details_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/watch_task_updates_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required this.getTaskDetailsUseCase,
    required this.createTaskUseCase,
    required this.updateTaskUseCase,
    required this.deleteTaskUseCase,
    required this.watchTaskUpdatesUseCase,
  }) : super(TaskInitial()) {
    on<GetTaskDetails>(_getTaskDetails);
    on<CreateTaskEvent>(_createTask);
    on<UpdateTaskEvent>(_updateTask);
    on<DeleteTask>(_deleteTask);
    on<UpdateToExistingTask>(_updateTaskInfo);
    on<OnTaskStreamEvent>(_onTaskStreamEvent);

    _taskSub = watchTaskUpdatesUseCase().listen((event) {
      add(OnTaskStreamEvent(event));
    });
  }

  final GetTaskDetailsUseCase getTaskDetailsUseCase;
  final CreateTaskUseCase createTaskUseCase;
  final UpdateTaskUseCase updateTaskUseCase;
  final DeleteTaskUseCase deleteTaskUseCase;
  final WatchTaskUpdatesUseCase watchTaskUpdatesUseCase;
  StreamSubscription<TaskStreamEvent>? _taskSub;

  Future<void> _getTaskDetails(GetTaskDetails event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await getTaskDetailsUseCase(event.taskId);
    result.fold(
      (l) => emit(TaskFailedState(errorMessage: l.message)),
      (r) => emit(TaskDetailsSuccess(task: r)),
    );
  }

  Future<void> _createTask(CreateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    String? authorId;
    try {
       const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: 'access_token');
      if (accessToken != null) {
        final decoded = JwtDecoder.decode(accessToken);
        authorId = decoded['sub'] as String?;
      }
    } catch (e, stackTrace) {
      log('Failed to decode JWT for authorId', error: e, stackTrace: stackTrace);
    }
    authorId ??= '';

    final result = await createTaskUseCase(
      taskId: event.taskId,
      title: event.title,
      priority: event.priority,
      categoryId: event.categoryId,
      authorId: authorId,
    );

    return await result.fold(
      (l) async => emit(TaskFailedState(errorMessage: l.message)),
      (r) async => emit(TaskCreationSuccess(task: r)),
    );
  }

  Future<void> _updateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await updateTaskUseCase(
      taskId: event.taskId,
      title: event.title,
      priority: event.priority,
      status: event.status,
    );
    return await result.fold(
      (l) async => emit(TaskFailedState(errorMessage: l.message)),
      (r) async => emit(TaskUpdateSuccess(task: r)),
    );
  }

  Future<void> _deleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await deleteTaskUseCase(event.taskId);
    await result.fold(
      (l) async => emit(TaskFailedState(errorMessage: l.message)),
      (r) async => emit(TaskDeletionSuccess(taskId: r)),
    );
  }

  FutureOr<void> _updateTaskInfo(UpdateToExistingTask event, Emitter<TaskState> emit) async {
    emit(TaskDetailsSuccess(task: event.task));
  }

  void _onTaskStreamEvent(OnTaskStreamEvent event, Emitter<TaskState> emit) {
    switch (event.event) {
      case TaskUpdatedEvent(:final task):
        emit(TaskDetailsSuccess(task: task));
      case TaskDeletedEvent(:final taskId):
        emit(TaskDeletionSuccess(taskId: taskId));
      case TaskCreatedEvent():
        // CREATE not relevant for single-task view
        break;
    }
  }

  @override
  Future<void> close() {
    _taskSub?.cancel();
    return super.close();
  }
}
