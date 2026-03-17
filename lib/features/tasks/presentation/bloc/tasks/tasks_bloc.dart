import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/core/network/failures.dart';
import 'package:taskflowapp/features/tasks/data/model/delete_task_response/delete_task_response.dart';
import 'package:taskflowapp/features/tasks/data/repository/tasks_repository.dart';
import 'package:taskflowapp/core/websocket/socket_service.dart';

import '../../../data/model/task/task.dart';
import '../../../local/repository/task_local_repository.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository repository;
  StreamSubscription? _taskSub;
  final LocalTasksRepository localRepo;

  String? _nextCursor;
  bool _isFetchingMore = false;
  bool _hasMore = false;
  final Set<Task> _allTasks = {};

  TasksBloc({required this.repository, required this.localRepo})
    : super(TasksInitial()) {
    on<ListUserTasks>(_listUserTasks);
    on<RemoveTaskFromList>(_removeTask);
    on<AddTaskToList>(_addTaskToEvent);
    on<UpdateOneTask>(_updateTaskList);
    on<LoadMoreTasks>(_loadMoreTasks);

    _taskSub = SocketService().taskUpdates.listen((event) {
     switch (event['event']) {
        case 'CREATE':
          Task newTask = Task.fromJson(event['data']);
          return add(AddTaskToList(task: newTask));
        case 'UPDATE':
          Task updatedTask = Task.fromJson(event['data']);
          return add(UpdateOneTask(task: updatedTask));
        case 'DELETE':
          final dto = DeleteTaskResponse.fromJson(event['data']);
          return add(RemoveTaskFromList(taskId: dto.taskId));
      }
    });
  }

  void _listUserTasks(ListUserTasks event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    _allTasks.clear();
    final cachedTasks = localRepo.getFilteredTasks(
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

    final result = await repository.listUserTasks(
      searchKey: event.searchKey,
      sortBy: event.sortBy,
      sortOrder: event.sortOrder,
      status: event.status,
      categoryId: event.categoryId,
    );
    return await result.fold(
      (l) async {
        if (cachedTasks.isEmpty && l.runtimeType != NetworkFailure) {
          return emit(TasksFailedState(errorMessage: l.message));
        }
        return emit(TasksListingSuccess(tasks: List.from(cachedTasks)));
      },
      (r) async {
        _hasMore = r.hasNextPage;
        _nextCursor = r.nextCursor;
        await localRepo.saveTasks(r.tasks);
        List<Task> allCached = localRepo.getFilteredTasks(
          categoryId: event.categoryId,
          searchKey: event.searchKey,
          sortBy: event.sortBy,
          sortOrder: event.sortOrder,
          status: event.status,
        );
        emit(TasksListingSuccess(tasks: List.from(allCached), hasMore: _hasMore));
      },
    );
  }

  void _removeTask(RemoveTaskFromList event, Emitter<TasksState> emit) async {
    if (state is TasksListingSuccess) {
      final currentState = state as TasksListingSuccess;
      localRepo.deleteTask(event.taskId);
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
      await localRepo.saveTask(event.task);
      int index = currentState.tasks.indexWhere(
        (t) => t.taskId == event.task.taskId,
      );
      List<Task> updatedList = List.from(currentState.tasks);
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
      emit(
        TasksListingSuccess(
          tasks: currentState.tasks.map((t) {
            if (t.taskId == event.task.taskId) {
              localRepo.saveTask(event.task);
              return event.task;
            }
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
    final result = await repository.listUserTasks(
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
      await localRepo.saveTasks(response.tasks);
      _allTasks.addAll(response.tasks);
      _nextCursor = response.nextCursor;
      _isFetchingMore = false;
      _hasMore = response.hasNextPage;
      List<Task> tasks = localRepo.getFilteredTasks(
        searchKey: event.searchKey,
        status: event.status,
        sortBy: event.sortBy,
        sortOrder: event.sortOrder,
        categoryId: event.categoryId,
      );
      emit(TasksListingSuccess(tasks: tasks, hasMore: _hasMore));
    });
  }

  @override
  Future<void> close() {
    _taskSub?.cancel();
    return super.close();
  }
}
