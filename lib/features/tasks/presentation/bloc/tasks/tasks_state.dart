part of 'tasks_bloc.dart';

@immutable
sealed class TasksState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

final class TasksListingSuccess extends TasksState {
  final List<Task> tasks;
  final bool isFetchingMore;
  final bool hasMore;

  TasksListingSuccess({
    required this.tasks,
    this.isFetchingMore = false,
    this.hasMore = false,
  });

  @override
  List<Object?> get props => [tasks, isFetchingMore, hasMore];
}

class TasksFailedState extends TasksState {
  final String errorMessage;

  TasksFailedState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}



