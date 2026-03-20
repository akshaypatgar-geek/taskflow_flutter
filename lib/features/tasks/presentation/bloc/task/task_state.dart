

part of 'task_bloc.dart';


@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

class TaskUpdateSuccess extends TaskState {
  final TaskEntity task;

  TaskUpdateSuccess({required this.task});
}

class TaskCreationSuccess extends TaskState {
  final TaskEntity task;

  TaskCreationSuccess({required this.task});
}

class TaskDeletionSuccess extends TaskState {
  final String taskId;

  TaskDeletionSuccess({required this.taskId});
}

class TaskDetailsSuccess extends TaskState {
  final TaskEntity task;

  TaskDetailsSuccess({required this.task});
}

class TaskLoading extends TaskState {}

class TaskFailedState extends TaskState {
  final String errorMessage;

  TaskFailedState({required this.errorMessage});
}
