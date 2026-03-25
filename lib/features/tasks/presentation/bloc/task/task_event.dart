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

  /// When true, keeps [TaskDetailsSuccess] visible with [TaskDetailsSuccess.isSaving]
  /// instead of full-screen [TaskLoading] (task details inline save).
  final bool keepDetailsVisible;

  UpdateTaskEvent({
    required this.taskId,
    this.title,
    this.priority,
    this.status,
    this.keepDetailsVisible = false,
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

/// Clears [TaskDetailsSuccess.saveFailureMessage] after showing inline error feedback.
class ClearTaskSaveFeedback extends TaskEvent {}

class TaskDetailsDraftTitleChanged extends TaskEvent {
  TaskDetailsDraftTitleChanged(this.title);
  final String title;
}

class TaskDetailsDraftPriorityChanged extends TaskEvent {
  TaskDetailsDraftPriorityChanged(this.priority);
  final String priority;
}

class TaskDetailsDraftStatusChanged extends TaskEvent {
  TaskDetailsDraftStatusChanged(this.status);
  final TaskStatusEnum status;
}

/// `true` = show title [TextFormField]; `false` = read-only, reset draft title to server.
class TaskDetailsTitleEditingChanged extends TaskEvent {
  TaskDetailsTitleEditingChanged(this.isEditing);
  final bool isEditing;
}

/// Validates drafts and runs inline update (details screen).
class TaskDetailsSubmitInline extends TaskEvent {}

/// Internal event: task update received from real-time stream (WebSocket).
class OnTaskStreamEvent extends TaskEvent {
  final TaskStreamEvent event;

  OnTaskStreamEvent(this.event);
}