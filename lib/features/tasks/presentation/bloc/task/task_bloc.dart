import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_status.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_stream_event.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/create_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/delete_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/get_task_details_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/update_task_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/watch_task_updates_use_case.dart';

part 'task_event.dart';
part 'task_state.dart';

/// BLoC that manages task details and inline task updates.
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
    on<ClearTaskSaveFeedback>(_clearTaskSaveFeedback);
    on<OnTaskStreamEvent>(_onTaskStreamEvent);
    on<TaskDetailsDraftTitleChanged>(_onDraftTitleChanged);
    on<TaskDetailsDraftPriorityChanged>(_onDraftPriorityChanged);
    on<TaskDetailsDraftStatusChanged>(_onDraftStatusChanged);
    on<TaskDetailsTitleEditingChanged>(_onTitleEditingChanged);
    on<TaskDetailsSubmitInline>(_submitInline);

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
      (r) => emit(TaskDetailsSuccess.fromTask(r)),
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
    final prev = state;
    TaskDetailsSuccess? previousDetails;
    if (prev is TaskDetailsSuccess) {
      previousDetails = prev;
    }

    if (event.keepDetailsVisible && previousDetails != null) {
      emit(
        previousDetails.copyWith(
          isSaving: true,
          clearSaveFailureMessage: true,
        ),
      );
    } else {
      emit(TaskLoading());
    }

    final result = await updateTaskUseCase(
      taskId: event.taskId,
      title: event.title,
      priority: event.priority,
      status: event.status,
    );
    return await result.fold(
      (l) async {
        if (event.keepDetailsVisible && previousDetails != null) {
          emit(
            previousDetails.copyWith(
              saveFailureMessage: l.message,
              isSaving: false,
            ),
          );
        } else {
          emit(TaskFailedState(errorMessage: l.message));
        }
      },
      (r) async {
        if (event.keepDetailsVisible) {
          emit(TaskDetailsSuccess.fromTask(r));
        } else {
          emit(TaskUpdateSuccess(task: r));
        }
      },
    );
  }

  void _onDraftTitleChanged(TaskDetailsDraftTitleChanged event, Emitter<TaskState> emit) {
    final s = state;
    if (s is! TaskDetailsSuccess) return;
    emit(s.copyWith(draftTitle: event.title, clearTitleFieldError: true));
  }

  void _onDraftPriorityChanged(TaskDetailsDraftPriorityChanged event, Emitter<TaskState> emit) {
    final s = state;
    if (s is! TaskDetailsSuccess) return;
    emit(s.copyWith(draftPriority: event.priority.toUpperCase()));
  }

  void _onDraftStatusChanged(TaskDetailsDraftStatusChanged event, Emitter<TaskState> emit) {
    final s = state;
    if (s is! TaskDetailsSuccess) return;
    emit(s.copyWith(draftStatus: event.status));
  }

  void _onTitleEditingChanged(TaskDetailsTitleEditingChanged event, Emitter<TaskState> emit) {
    final s = state;
    if (s is! TaskDetailsSuccess) return;
    if (event.isEditing) {
      emit(
        s.copyWith(
          isEditingTitle: true,
          draftTitle: s.task.title,
          clearTitleFieldError: true,
        ),
      );
    } else {
      emit(
        s.copyWith(
          isEditingTitle: false,
          draftTitle: s.task.title,
          clearTitleFieldError: true,
        ),
      );
    }
  }

  void _submitInline(TaskDetailsSubmitInline event, Emitter<TaskState> emit) {
    final s = state;
    if (s is! TaskDetailsSuccess) return;

    final title = s.draftTitle.trim();
    if (title.isEmpty) {
      emit(s.copyWith(titleFieldError: AppStrings.titleRequired));
      return;
    }
    if (title.length > AppStrings.taskTitleMaxLength) {
      emit(s.copyWith(titleFieldError: AppStrings.titleTooLong));
      return;
    }

    add(
      UpdateTaskEvent(
        taskId: s.task.taskId,
        title: title,
        priority: s.draftPriority,
        status: s.draftStatus.name,
        keepDetailsVisible: true,
      ),
    );
  }

  void _clearTaskSaveFeedback(ClearTaskSaveFeedback event, Emitter<TaskState> emit) {
    final s = state;
    if (s is TaskDetailsSuccess && s.saveFailureMessage != null) {
      emit(s.copyWith(clearSaveFailureMessage: true));
    }
  }

  Future<void> _deleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await deleteTaskUseCase(event.taskId);
    await result.fold(
      (l) async => emit(TaskFailedState(errorMessage: l.message)),
      (r) async => emit(TaskDeletionSuccess(taskId: r)),
    );
  }

  Future<void> _updateTaskInfo(UpdateToExistingTask event, Emitter<TaskState> emit) async {
    emit(TaskDetailsSuccess.fromTask(event.task));
  }

  void _onTaskStreamEvent(OnTaskStreamEvent event, Emitter<TaskState> emit) {
    switch (event.event) {
      case TaskUpdatedEvent(:final task):
        final cur = state;
        if (cur is TaskDetailsSuccess && cur.task.taskId == task.taskId) {
          if (cur.hasUnsavedDraftChanges) {
            emit(cur.copyWith(task: task));
          } else {
            emit(TaskDetailsSuccess.fromTask(task));
          }
        } else {
          emit(TaskDetailsSuccess.fromTask(task));
        }
      case TaskDeletedEvent(:final taskId):
        emit(TaskDeletionSuccess(taskId: taskId));
      case TaskCreatedEvent():
        break;
    }
  }

  @override
  Future<void> close() {
    _taskSub?.cancel();
    return super.close();
  }
}
