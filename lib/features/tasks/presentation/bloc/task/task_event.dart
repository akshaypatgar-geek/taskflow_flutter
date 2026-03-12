part of 'task_bloc.dart';


sealed class TaskEvent {}

class CreateTaskEvent extends TaskEvent{
  final String taskId;
  final String title;
  String? priority;
  String? categoryId;

  CreateTaskEvent({required this.taskId, required this.title, this.priority, this.categoryId});
}

class UpdateTaskEvent extends TaskEvent {
  final String taskId;
  String? title;
  String? priority;
  String? status;

  UpdateTaskEvent({required this.taskId,this.title, this.priority, this.status});
}

class DeleteTask extends TaskEvent {
  final String taskId;

  DeleteTask({required this.taskId});
}

class GetTaskDetails extends TaskEvent {
  final String taskId;

  GetTaskDetails({required this.taskId});
}



class UpdateToExistingTask extends TaskEvent {
  final Task task;

  UpdateToExistingTask({required this.task});
 }