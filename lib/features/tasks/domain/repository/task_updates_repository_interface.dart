import 'package:taskflowapp/features/tasks/domain/entities/task_stream_event.dart';

/// Contract for watching real-time task updates (e.g. via WebSocket).
abstract interface class TaskUpdatesRepository {
  Stream<TaskStreamEvent> watchTaskUpdates();
}
