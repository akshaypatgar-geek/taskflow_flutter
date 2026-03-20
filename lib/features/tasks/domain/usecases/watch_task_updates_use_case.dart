import 'package:taskflowapp/features/tasks/domain/entities/task_stream_event.dart';
import 'package:taskflowapp/features/tasks/domain/repository/task_updates_repository_interface.dart';

/// Use case: Watch real-time task updates (create, update, delete) via WebSocket.
class WatchTaskUpdatesUseCase {
  WatchTaskUpdatesUseCase(this._repository);

  final TaskUpdatesRepository _repository;

  Stream<TaskStreamEvent> call() => _repository.watchTaskUpdates();
}
