import 'package:taskflowapp/core/network/dio_client.dart';
import 'package:taskflowapp/core/network/end_points.dart';

abstract class NotificationRepository {
  Future<void> subscribeToTopic(String fcmToken);
}

class NotificationRepositoryImpl implements NotificationRepository {
  final DioClient _client;

  NotificationRepositoryImpl(this._client);

  @override
  Future<void> subscribeToTopic(String fcmToken) async {
    try {
      await _client.postRequest(
        endpoint: EndPoints.subscribeToTopic,
        body: {'fcmToken': fcmToken},
      );
    } catch (e) {
      // Log error or handle as needed
      rethrow;
    }
  }
}
