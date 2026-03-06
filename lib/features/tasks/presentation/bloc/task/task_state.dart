// import 'package:equatable/equatable.dart';

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
}

class TaskCreationSuccess extends TaskState {
  final Task task;

  TaskCreationSuccess({required this.task});

}


class TaskDeletionSuccess extends TaskState {
  final String taskId;

  TaskDeletionSuccess({required this.taskId});
}

class TaskDetailsSuccess extends TaskState {
  final Task task;

  TaskDetailsSuccess({required this.task});
}

class TaskLoading extends TaskState {}

class TaskFailedState extends TaskState {
  final String errorMessage;

  TaskFailedState({required this.errorMessage});

}
