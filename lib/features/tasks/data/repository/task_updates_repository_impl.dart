import 'package:taskflowapp/core/socket_events.dart';
import 'package:taskflowapp/core/socket_service.dart';
import 'package:taskflowapp/features/tasks/data/mapper/task_entity_mapper.dart';
import 'package:taskflowapp/features/tasks/data/model/delete_task_response/delete_task_response.dart';
import 'package:taskflowapp/features/tasks/data/model/task_model/task_model.dart';
import 'package:taskflowapp/features/tasks/domain/entities/task_stream_event.dart';
import 'package:taskflowapp/features/tasks/domain/repository/task_updates_repository_interface.dart';

class TaskUpdatesRepositoryImpl implements TaskUpdatesRepository {
  TaskUpdatesRepositoryImpl(this._socketService);

  final SocketService _socketService;

  @override
  Stream<TaskStreamEvent> watchTaskUpdates() async* {
    await for (final event in _socketService.taskUpdates) {
      switch (event) {
        case TaskSocketCreated(:final payload):
          final model = TaskModel.fromJson(payload);
          final entity = TaskEntityMapper.toEntity(model);
          yield TaskCreatedEvent(entity);
        case TaskSocketUpdated(:final payload):
          final model = TaskModel.fromJson(payload);
          final entity = TaskEntityMapper.toEntity(model);
          yield TaskUpdatedEvent(entity);
        case TaskSocketDeleted(:final payload):
          final dto = DeleteTaskResponse.fromJson(payload);
          yield TaskDeletedEvent(dto.taskId);
      }
    }
  }
}
