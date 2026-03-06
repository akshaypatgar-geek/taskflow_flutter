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
  TasksBloc({required this.repository}) : super(TasksInitial()) {
    on<ListUserTasks>(_listUserTasks);
    on<RemoveTaskFromList>(_removeTask);
    on<AddTaskToList>(_addTaskToEvent);
    on<UpdateOneTask>(_updateTaskList);

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
    final result = await repository.listUserTasks();
    result.fold((l) =>emit(TasksFailedState(errorMessage: l.message)),
    (r) =>emit(TasksListingSuccess(tasks: r.tasks)),);
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
}
