import 'package:hive_ce/hive.dart';
import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/offline/offline_request.dart';
import 'package:taskflowapp/core/offline/offline_request_hive.dart';

class OfflineRequestRepository {
  final Box<OfflineRequestHive> offlineBox;
  final DioClient client;

  OfflineRequestRepository({required this.offlineBox, required this.client});

  Future<void> addNewRequest(OfflineRequest options) async {
    OfflineRequestHive req = OfflineRequestHive(method: options.method, endPoint: options.endpoint, body: options.body, queryParameters: options.queryParams, createdAt: DateTime.now().toString());
    offlineBox.put(req.createdAt, req);
  }

  Future<void> deleteRequest({required OfflineRequestHive request}) async {
    await offlineBox.delete(request.createdAt);
  }

  List<OfflineRequestHive> getPendingRequests() {
    List<OfflineRequestHive> pendingTasks = offlineBox.values.toList();
    return pendingTasks;
  }

  Future<void> executeRequest(OfflineRequestHive options) async {
    try {
      switch (options.method) {
        case 'POST':
        await client.postRequest(endpoint: options.endPoint,body: options.body,
        );
        break;
        case "GET":
        await client.getRequest(endpoint: options.endPoint, queryParams: options.queryParameters);
        break;
        case 'PATCH':
        await client.patchRequest(endpoint: options.endPoint,
        body: options.body);
        break;
        case 'DELETE':
        await client.deleteRequest(endpoint: options.endPoint,body: options.body,queryParams: options.queryParameters);

      }
    } catch(e) {

    } finally {
      deleteRequest(request: options);
    }
  }


}