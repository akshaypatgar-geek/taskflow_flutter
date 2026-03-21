part of 'task_bloc.dart';


sealed class TaskEvent {}

class CreateTaskEvent extends TaskEvent {
  final String taskId;
  final String title;
  final String? priority;
  final String? categoryId;

  CreateTaskEvent({
    required this.taskId,
    required this.title,
    this.priority,
    this.categoryId,
  });
}

class UpdateTaskEvent extends TaskEvent {
  final String taskId;
  final String? title;
  final String? priority;
  final String? status;

  UpdateTaskEvent({
    required this.taskId,
    this.title,
    this.priority,
    this.status,
  });
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
  final TaskEntity task;

  UpdateToExistingTask({required this.task});
}

/// Internal event: task update received from real-time stream (WebSocket).
class OnTaskStreamEvent extends TaskEvent {
  final TaskStreamEvent event;

  OnTaskStreamEvent(this.event);
}