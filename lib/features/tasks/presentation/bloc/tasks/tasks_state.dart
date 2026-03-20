part of 'tasks_bloc.dart';

@immutable
sealed class TasksState  {
}

final class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

final class TasksListingSuccess extends TasksState {
  final List<TaskEntity> tasks;
  final bool isFetchingMore;
  final bool hasMore;

  TasksListingSuccess({
    required this.tasks,
    this.isFetchingMore = false,
    this.hasMore = false,
  });

 }

class TasksFailedState extends TasksState {
  final String errorMessage;

  TasksFailedState({required this.errorMessage});

  }



