part of 'tasks_bloc.dart';

@immutable
sealed class TasksState {}

final class TasksInitial extends TasksState {}

class  TasksLoading extends TasksState{}

final class TasksListingSuccess extends TasksState{
  final List<Task> tasks;

  TasksListingSuccess({required this.tasks});
}


class TasksFailedState extends TasksState {
  final String errorMessage;

  TasksFailedState({required this.errorMessage});
}



