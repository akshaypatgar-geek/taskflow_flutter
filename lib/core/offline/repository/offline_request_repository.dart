import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/offline/offline_request.dart';
import 'package:taskflowapp/core/offline/offline_request_hive.dart';
import 'package:taskflowapp/core/utils/constants.dart';

/// Persists and executes HTTP requests that were created while offline.
/// Uses a Hive box keyed by creation timestamp.
class OfflineRequestRepository {
  final Box<OfflineRequestHive> offlineBox;
  final DioClient client;

  OfflineRequestRepository({required this.offlineBox, required this.client});

  Future<void> addNewRequest(OfflineRequest options) async {
   final OfflineRequestHive req = OfflineRequestHive(method: options.method, endPoint: options.endpoint, body: options.body, queryParameters: options.queryParams, createdAt: DateTime.now().toString());
    offlineBox.put(req.createdAt, req);
  }

  Future<void> deleteRequest({required OfflineRequestHive request}) async {
    await offlineBox.delete(request.createdAt);
  }

  List<OfflineRequestHive> getPendingRequests() {
   final List<OfflineRequestHive> pendingTasks = offlineBox.values.toList();
    return pendingTasks;
  }

  /// Executes a queued offline request. Throws on failure so the caller
  /// can decide whether to retry or discard.
  Future<void> executeRequest(OfflineRequestHive options) async {
    switch (options.method) {
      case HttpMethods.post:
        await client.postRequest<Map<String, dynamic>>(endpoint: options.endPoint, body: options.body);
        break;
      case HttpMethods.get:
        await client.getRequest<Map<String, dynamic>>(endpoint: options.endPoint, queryParams: options.queryParameters);
        break;
      case HttpMethods.patch:
        await client.patchRequest<Map<String, dynamic>>(endpoint: options.endPoint, body: options.body);
        break;
      case HttpMethods.delete:
        await client.deleteRequest<Map<String, dynamic>>(endpoint: options.endPoint, body: options.body, queryParams: options.queryParameters);
        break;
      default:
        throw ArgumentError('Unsupported HTTP method: ${options.method}');
    }
    await deleteRequest(request: options);
  }
}