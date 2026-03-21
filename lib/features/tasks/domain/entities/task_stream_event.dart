import 'package:taskflowapp/features/tasks/domain/entities/task_entity/task_entity.dart';

/// Domain event for task updates from real-time source (e.g. WebSocket).
sealed class TaskStreamEvent {}

class TaskCreatedEvent extends TaskStreamEvent {
  final TaskEntity task;

  TaskCreatedEvent(this.task);
}

class TaskUpdatedEvent extends TaskStreamEvent {
  final TaskEntity task;

  TaskUpdatedEvent(this.task);
}

class TaskDeletedEvent extends TaskStreamEvent {
  final String taskId;

  TaskDeletedEvent(this.taskId);
}
