import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/features/tasks/data/model/delete_task_response/delete_task_response.dart';
import 'package:taskflowapp/features/tasks/data/repository/tasks_repository.dart';
import 'package:taskflowapp/services/websocket/Socket_service.dart';

import '../../../data/model/task/task.dart';
import 'dart:developer';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository repository;
  StreamSubscription? _taskSub;

  String? nextCursor;       
  bool isFetchingMore = false;
  bool hasMore = false;
  List<Task> allTasks = [];
  
  TasksBloc({required this.repository}) : super(TasksInitial()) {
    on<ListUserTasks>(_listUserTasks);
    on<RemoveTaskFromList>(_removeTask);
    on<AddTaskToList>(_addTaskToEvent);
    on<UpdateOneTask>(_updateTaskList);
    on<LoadMoreTasks>(_loadMoreTasks);

    _taskSub = SocketService().taskUpdates.listen((event) {
      log("inside listener :$event");
      switch(event['event']) {
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
    allTasks.clear(); 
    final result = await repository.listUserTasks(searchKey: event.searchKey, sortBy: event.sortBy, sortOrder: event.sortOrder, status: event.status, categoryId: event.categoryId);
    result.fold((l) =>emit(TasksFailedState(errorMessage: l.message)),
    (r) {
      hasMore = r.hasNextPage;
      nextCursor = r.nextCursor;
      allTasks.addAll(r.tasks);
      emit(TasksListingSuccess(tasks: allTasks));},);
  }

  void _removeTask(RemoveTaskFromList event, Emitter<TasksState> emit) async {
    if(state is TasksListingSuccess) {
      final currentState = state as TasksListingSuccess;
      final updatedList = currentState.tasks.where((t)=>t.taskId != event.taskId).toList();
      emit(TasksListingSuccess(tasks: updatedList));
    }
  }

  

  FutureOr<void> _addTaskToEvent(AddTaskToList event, Emitter<TasksState> emit) async{
    if(state is TasksListingSuccess) {
      final currentState = state as TasksListingSuccess;
      emit(TasksListingSuccess(tasks: [...currentState.tasks,event.task]));
    }
  }

  FutureOr<void> _updateTaskList(UpdateOneTask event, Emitter<TasksState> emit)async {
    if(state is TasksListingSuccess) {
      final currentState = state as TasksListingSuccess;
      emit(TasksListingSuccess(tasks: currentState.tasks.map((t) {
        if(t.taskId == event.task.taskId) {
          return event.task;
        }
        return t;
      }).toList()));
    }
  }

  void _loadMoreTasks(LoadMoreTasks event, Emitter<TasksState> emit) async {
    log("api for more tasks");
  if (nextCursor == null || isFetchingMore) return; // throttle
  isFetchingMore = true;
  final result = await repository.listUserTasks(
    searchKey: event.searchKey,
    status: event.status,
    sortBy: event.sortBy,
    sortOrder: event.sortOrder,
    cursor: nextCursor,
    limit: 10,
    categoryId: event.categoryId
  );
  log("got the response:$result");
  result.fold(
    (_) => isFetchingMore = false,
    (response) {
     
      allTasks.addAll(response.tasks); 
      nextCursor = response.nextCursor;
      isFetchingMore = false;
      hasMore = response.hasNextPage;


      emit(TasksListingSuccess(tasks: allTasks)); 
    },
  );
}
}
