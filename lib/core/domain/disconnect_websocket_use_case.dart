import 'package:taskflowapp/core/socket_service.dart';

/// Disconnects the active websocket session if one exists.
class DisconnectWebSocketUseCase {
  DisconnectWebSocketUseCase({required this.socketService});

  final SocketService socketService;

  void call() {
    socketService.disconnect();
  }
}
