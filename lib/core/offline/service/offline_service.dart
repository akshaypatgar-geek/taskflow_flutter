import 'dart:developer';

import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/exceptions.dart';
import 'package:taskflowapp/core/offline/offline_request_hive.dart';
import 'package:taskflowapp/core/offline/repository/offline_request_repository.dart';
import 'package:taskflowapp/core/utils/constants.dart';
import 'package:taskflowapp/features/tasks/local/model/task_hive/task_hive.dart';

class OfflineSyncResult {
  const OfflineSyncResult({
    this.errorMessages = const <String>[],
    this.removedTaskIds = const <String>[],
  });

  final List<String> errorMessages;
  final List<String> removedTaskIds;
}

/// Replays queued offline requests when the device regains connectivity.
/// Skips individual failures so one bad request doesn't block the queue.
class OfflineSyncService {
  final OfflineRequestRepository offlineRepo;

  OfflineSyncService(this.offlineRepo);

  bool _isSyncing = false;

  Future<OfflineSyncResult> retryPendingRequests() async {
    if (_isSyncing) return const OfflineSyncResult();
    _isSyncing = true;
    final errorMessages = <String>[];
    final removedTaskIds = <String>[];

    try {
      final pending = offlineRepo.getPendingRequests();

      for (final request in pending) {
        try {
          await offlineRepo.executeRequest(request);
        } catch (e, stackTrace) {
          if (e is NotFoundException &&
              request.method == HttpMethods.patch &&
              _isTaskUpdateEndpoint(request.endPoint)) {
            await _discardDeletedTaskUpdate(
              request: request,
              errorMessages: errorMessages,
              removedTaskIds: removedTaskIds,
            );
            continue;
          }

          if (e is AppException) {
            errorMessages.add(e.message);
          }
          if (e is! NetworkException) {
            await offlineRepo.deleteRequest(request: request);
          }
          log(
            'Offline sync failed for ${request.method} ${request.endPoint}',
            error: e,
            stackTrace: stackTrace,
          );
        }
      }
      return OfflineSyncResult(
        errorMessages: errorMessages,
        removedTaskIds: removedTaskIds,
      );
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _discardDeletedTaskUpdate({
    required OfflineRequestHive request,
    required List<String> errorMessages,
    required List<String> removedTaskIds,
  }) async {
    final taskId =
        _taskIdFromEndpoint(request.endPoint) ?? _taskIdFromRequestBody(request.body);
    final taskTitle = _taskTitleFromRequestBody(request.body) ?? taskId ?? 'task';

    errorMessages.add(AppStrings.taskRemovedAfterSync(taskTitle));
    if (taskId != null) {
      await _deleteTaskFromLocalHive(taskId);
      removedTaskIds.add(taskId);
    }
    await offlineRepo.deleteRequest(request: request);
  }

  String? _taskIdFromEndpoint(String endpoint) {
    final match = RegExp(r'^/tasks/([^/?]+)').firstMatch(endpoint);
    return match?.group(1);
  }

  String? _taskIdFromRequestBody(Map<String, dynamic>? body) {
    if (body == null) return null;
    final id = body['id'];
    if (id is String && id.trim().isNotEmpty) {
      return id.trim();
    }
    return null;
  }

  String? _taskTitleFromRequestBody(Map<String, dynamic>? body) {
    if (body == null) return null;
    final title = body['title'];
    if (title is String && title.trim().isNotEmpty) {
      return title.trim();
    }
    return null;
  }

  Future<void> _deleteTaskFromLocalHive(String taskId) async {
    final taskBox = Hive.box<TaskHive>('tasks');
    await taskBox.delete(taskId);
  }

  bool _isTaskUpdateEndpoint(String endpoint) {
    return endpoint == '/tasks' || endpoint.startsWith('/tasks/');
  }
}