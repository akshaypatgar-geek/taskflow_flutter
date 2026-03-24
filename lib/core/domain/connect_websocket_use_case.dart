import 'package:taskflowapp/core/offline/service/offline_service.dart';
import 'package:taskflowapp/core/socket_service.dart';

import '../session_manager/session_manager.dart';


class ConnectWebSocketUseCase {
  ConnectWebSocketUseCase({
    required this.sessionManager,
    required this.socketService,
    required this.offlineSyncService,
  });

  final SessionManager sessionManager;
  final SocketService socketService;
  final OfflineSyncService offlineSyncService;

  Future<void> call() async {
    final accessToken = await sessionManager.getAccessToken();
    if (accessToken != null) {
      await socketService.connect(accessToken);
      offlineSyncService.retryPendingRequests();
    }
  }
}
