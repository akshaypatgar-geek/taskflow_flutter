import 'package:equatable/equatable.dart';

import 'task_entity/task_entity.dart';

class ListTasksResult extends Equatable {
  const ListTasksResult({
    required this.tasks,
    this.nextCursor,
    required this.hasNextPage,
  });

  final List<TaskEntity> tasks;
  final String? nextCursor;
  final bool hasNextPage;

  @override
  List<Object?> get props => [tasks, nextCursor, hasNextPage];
}
