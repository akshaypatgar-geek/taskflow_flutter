part of 'tasks_bloc.dart';

sealed class TasksEvent {}

class ListUserTasks extends TasksEvent{}

class RemoveTaskFromList extends TasksEvent {
  final String taskId;

  RemoveTaskFromList({required this.taskId});
}

class AddTaskToList extends TasksEvent {
  final Task task;

  AddTaskToList({required this.task});
}

class UpdateOneTask extends TasksEvent {
  final Task task;

  UpdateOneTask({required this.task});
}

// class CreateTaskEvent extends TasksEvent{
//   final String title;
//   String? priority;
//   String? categoryId;

//   CreateTaskEvent({required this.title, this.priority, this.categoryId});
// }


