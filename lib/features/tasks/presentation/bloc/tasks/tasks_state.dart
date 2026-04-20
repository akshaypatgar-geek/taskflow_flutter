part of 'tasks_bloc.dart';

sealed class TasksState extends Equatable {
  const TasksState();

  @override
  List<Object?> get props => [];
}

final class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

final class TasksListingSuccess extends TasksState {
  final List<TaskEntity> tasks;
  final bool isFetchingMore;
  final bool hasMore;
  final String? nextCursor;

  TasksListingSuccess({
    required this.tasks,
    this.isFetchingMore = false,
    this.hasMore = false,
    this.nextCursor,
  });

  TasksListingSuccess copyWith({
    List<TaskEntity>? tasks,
    bool? isFetchingMore,
    bool? hasMore,
    String? nextCursor,
    bool clearNextCursor = false,
  }) {
    return TasksListingSuccess(
      tasks: tasks ?? this.tasks,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMore: hasMore ?? this.hasMore,
      nextCursor: clearNextCursor ? null : (nextCursor ?? this.nextCursor),
    );
  }

  @override
  List<Object?> get props => [tasks, isFetchingMore, hasMore, nextCursor];
}

class TasksFailedState extends TasksState {
  final String errorMessage;

  TasksFailedState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}



