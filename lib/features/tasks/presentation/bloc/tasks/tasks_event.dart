part of 'tasks_bloc.dart';

sealed class TasksEvent {}

class ResetTasksEvent extends TasksEvent {}

class ListUserTasks extends TasksEvent{
  final String? searchKey;
  final String? status;
  final String sortBy;
  final String sortOrder;
  final String? categoryId;

  ListUserTasks({
    this.searchKey,
    this.status,
    this.sortBy = 'date',
    this.sortOrder = 'desc',
    this.categoryId
  });
}

class RemoveTaskFromList extends TasksEvent {
  final String taskId;

  RemoveTaskFromList({required this.taskId});
}

class AddTaskToList extends TasksEvent {
  final TaskEntity task;

  AddTaskToList({required this.task});
}

class UpdateOneTask extends TasksEvent {
  final TaskEntity task;

  UpdateOneTask({required this.task});
}

class LoadMoreTasks extends TasksEvent {
  final String? searchKey;
  final String? status;
  final String sortBy;
  final String sortOrder;
  final String? categoryId;
  

  LoadMoreTasks({ this.searchKey,  this.status, this.sortBy = "date",  this.sortOrder= "desc", this.categoryId});
}




