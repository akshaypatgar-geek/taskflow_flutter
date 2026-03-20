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
      final type = event['event'] as String?;
      final data = event['data'];

      if (data == null || data is! Map<String, dynamic>) continue;

      switch (type) {
        case 'CREATE':
        case 'UPDATE':
          final model = TaskModel.fromJson(data);
          final entity = TaskEntityMapper.toEntity(model);
          yield type == 'CREATE'
              ? TaskCreatedEvent(entity)
              : TaskUpdatedEvent(entity);
        case 'DELETE':
          final dto = DeleteTaskResponse.fromJson(data);
          yield TaskDeletedEvent(dto.taskId);
        default:
          break;
      }
    }
  }
}
