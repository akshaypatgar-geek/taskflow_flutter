import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:taskflowapp/features/tasks/data/repository/task_repository.dart';
import 'package:taskflowapp/features/tasks/local/repository/task_local_repository.dart';

import '../../../../../services/websocket/Socket_service.dart';
import '../../../data/model/delete_task_response/delete_task_response.dart';
import '../../../data/model/task/task.dart';
import 'package:equatable/equatable.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;
  final SocketService socketService;
  final LocalTasksRepository localRepository;
  StreamSubscription? taskSub;
  TaskBloc({required this.repository, required this.socketService, required this.localRepository}) : super(TaskInitial()) {
     on<GetTaskDetails>(_getTaskDetails);
     on<CreateTaskEvent>(_createTask);
    on<UpdateTaskEvent>(_updateTask);
    on<DeleteTask>(_deleteTask);
    on<UpdateToExistingTask>(_updateTaskInfo);
    taskSub = socketService.taskUpdates.listen((event) {
      log("inside listener :$event");
      switch(event['event']) {
        case 'UPDATE':
        Task updatedTask = Task.fromJson(event['data']);
        return add(UpdateToExistingTask(task: updatedTask));
        case 'DELETE':
        final dto = DeleteTaskResponse.fromJson(event['data']);
        // ignore: invalid_use_of_visible_for_testing_member
        return emit(TaskDeletionSuccess(taskId: dto.taskId));
      }
    });
  }

  void _getTaskDetails(GetTaskDetails event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final cachedTask = localRepository.getTaskById(event.taskId);
    if(cachedTask !=null) {
      emit(TaskDetailsSuccess(task: cachedTask));
    }
    final result = await repository.getTaskDetails(taskId: event.taskId);
    result.fold((l) {
      if(cachedTask !=null) {
        return emit(TaskDetailsSuccess(task: cachedTask));
      }
     return emit(TaskFailedState(errorMessage: l.message));
    } , (r) => emit(TaskDetailsSuccess(task: r)),);
  }

  void _createTask(CreateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await repository.createTask(taskTitle: event.title, priority: event.priority, categoryId: event.categoryId);
    result.fold((l) => emit(TaskFailedState(errorMessage: l.message)),
    (r) => emit(TaskCreationSuccess(task: r)),);
  }

  void _updateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    final result = await repository.updateTask(id: event.taskId, priority: event.priority, status: event.status, title: event.title );
    result.fold((l) => emit(TaskFailedState(errorMessage: l.message)),
    (r) => emit(TaskUpdateSuccess(task: r)),);
  }

  void _deleteTask(DeleteTask event, Emitter<TaskState> emit)async {
    emit(TaskLoading());
    final result = await repository.deleteTask(taskId: event.taskId);
    result.fold((l) => emit(TaskFailedState(errorMessage: l.message)), (r) {
      emit(TaskDeletionSuccess(taskId: r.taskId));
    } ,);
  }

  FutureOr<void> _updateTaskInfo(UpdateToExistingTask event, Emitter<TaskState> emit) async{
    emit(TaskDetailsSuccess(task: event.task));
  }
}
