import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_stream_event.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/delete_task_locally_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/get_cached_filtered_tasks_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/list_user_tasks_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/save_task_locally_use_case.dart';
import 'package:taskflowapp/features/tasks/domain/usecases/watch_task_updates_use_case.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc({
    required this.getCachedFilteredTasksUseCase,
    required this.listUserTasksUseCase,
    required this.saveTaskLocallyUseCase,
    required this.deleteTaskLocallyUseCase,
    required this.watchTaskUpdatesUseCase,
  }) : super(TasksInitial()) {
    on<ListUserTasks>(_listUserTasks);
    on<RemoveTaskFromList>(_removeTask);
    on<AddTaskToList>(_addTaskToEvent);
    on<UpdateOneTask>(_updateTaskList);
    on<LoadMoreTasks>(_loadMoreTasks);

    _taskSub = watchTaskUpdatesUseCase().listen((event) {
      switch (event) {
        case TaskCreatedEvent(:final task):
          add(AddTaskToList(task: task));
        case TaskUpdatedEvent(:final task):
          add(UpdateOneTask(task: task));
        case TaskDeletedEvent(:final taskId):
          add(RemoveTaskFromList(taskId: taskId));
      }
    });
  }

  final GetCachedFilteredTasksUseCase getCachedFilteredTasksUseCase;
  final ListUserTasksUseCase listUserTasksUseCase;
  final SaveTaskLocallyUseCase saveTaskLocallyUseCase;
  final DeleteTaskLocallyUseCase deleteTaskLocallyUseCase;
  final WatchTaskUpdatesUseCase watchTaskUpdatesUseCase;
  StreamSubscription<TaskStreamEvent>? _taskSub;

  String? _nextCursor;
  bool _isFetchingMore = false;
  bool _hasMore = false;
  final Set<TaskEntity> _allTasks = {};

  void _listUserTasks(ListUserTasks event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    _allTasks.clear();
    final cachedTasks = await getCachedFilteredTasksUseCase(
      categoryId: event.categoryId,
      searchKey: event.searchKey,
      sortBy: event.sortBy,
      sortOrder: event.sortOrder,
      status: event.status,
    );
    if (cachedTasks.isNotEmpty) {
      _allTasks.addAll(cachedTasks);
      emit(TasksListingSuccess(tasks: _allTasks.toList()));
    }

    final result = await listUserTasksUseCase(
      searchKey: event.searchKey,
      sortBy: event.sortBy,
      sortOrder: event.sortOrder,
      status: event.status,
      categoryId: event.categoryId,
    );
    return await result.fold(
      (l) async {
        if (cachedTasks.isEmpty && !l.isRetryable) {
          return emit(TasksFailedState(errorMessage: l.message));
        }
        return emit(TasksListingSuccess(tasks: List.from(cachedTasks)));
      },
      (r) async {
        _hasMore = r.hasNextPage;
        _nextCursor = r.nextCursor;
        _allTasks.clear();
        _allTasks.addAll(r.tasks);
        emit(TasksListingSuccess(tasks: r.tasks, hasMore: _hasMore));
      },
    );
  }

  void _removeTask(RemoveTaskFromList event, Emitter<TasksState> emit) async {
    if (state is TasksListingSuccess) {
      final currentState = state as TasksListingSuccess;
      await deleteTaskLocallyUseCase(event.taskId);
      final updatedList = currentState.tasks
          .where((t) => t.taskId != event.taskId)
          .toList();
      emit(TasksListingSuccess(tasks: updatedList));
    }
  }

  FutureOr<void> _addTaskToEvent(
    AddTaskToList event,
    Emitter<TasksState> emit,
  ) async {
    if (state is TasksListingSuccess) {
      final currentState = state as TasksListingSuccess;
      await saveTaskLocallyUseCase(event.task);
      final index = currentState.tasks.indexWhere(
        (t) => t.taskId == event.task.taskId,
      );
      final updatedList = List<TaskEntity>.from(currentState.tasks);
      if (index == -1) {
        updatedList.insert(0, event.task);
      } else {
        updatedList[index] = event.task;
      }
      emit(TasksListingSuccess(tasks: updatedList));
    }
  }

  FutureOr<void> _updateTaskList(
    UpdateOneTask event,
    Emitter<TasksState> emit,
  ) async {
    if (state is TasksListingSuccess) {
      final currentState = state as TasksListingSuccess;
      await saveTaskLocallyUseCase(event.task);
      emit(
        TasksListingSuccess(
          tasks: currentState.tasks.map((t) {
            if (t.taskId == event.task.taskId) return event.task;
            return t;
          }).toList(),
        ),
      );
    }
  }

  void _loadMoreTasks(LoadMoreTasks event, Emitter<TasksState> emit) async {
    if (_nextCursor == null || _isFetchingMore) return;
    _isFetchingMore = true;
    if (state is TasksListingSuccess) {
      final current = state as TasksListingSuccess;
      emit(TasksListingSuccess(tasks: current.tasks, isFetchingMore: true, hasMore: _hasMore));
    }
    final result = await listUserTasksUseCase(
      searchKey: event.searchKey,
      status: event.status,
      sortBy: event.sortBy,
      sortOrder: event.sortOrder,
      cursor: _nextCursor,
      limit: 10,
      categoryId: event.categoryId,
    );
    return await result.fold((_) {
      _isFetchingMore = false;
      if (state is TasksListingSuccess) {
        final current = state as TasksListingSuccess;
        emit(TasksListingSuccess(tasks: current.tasks, isFetchingMore: false, hasMore: _hasMore));
      }
    }, (response) async {
      _allTasks.addAll(response.tasks);
      _nextCursor = response.nextCursor;
      _isFetchingMore = false;
      _hasMore = response.hasNextPage;
      emit(TasksListingSuccess(tasks: _allTasks.toList(), hasMore: _hasMore));
    });
  }

  @override
  Future<void> close() {
    _taskSub?.cancel();
    return super.close();
  }
}
