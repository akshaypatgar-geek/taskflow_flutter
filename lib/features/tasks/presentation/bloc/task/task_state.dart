

part of 'task_bloc.dart';


@immutable
sealed class TaskState extends Equatable{
  @override
  List<Object?> get props => [];
}

final class TaskInitial extends TaskState {}

class TaskUpdateSuccess extends TaskState {
  final Task task;

  TaskUpdateSuccess({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskCreationSuccess extends TaskState {
  final Task task;

  TaskCreationSuccess({required this.task});

  @override
  List<Object?> get props => [task];
}


class TaskDeletionSuccess extends TaskState {
  final String taskId;

  TaskDeletionSuccess({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

class TaskDetailsSuccess extends TaskState {
  final Task task;

  TaskDetailsSuccess({required this.task});

  @override
  List<Object?> get props => [task];
}

class TaskLoading extends TaskState {}

class TaskFailedState extends TaskState {
  final String errorMessage;

  TaskFailedState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
