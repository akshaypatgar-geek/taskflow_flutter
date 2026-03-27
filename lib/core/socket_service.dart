import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'socket_events.dart';

/// Singleton WebSocket service using Socket.IO. Connects with JWT auth,
/// listens for task CRUD events, and exposes a broadcast [Stream<TaskSocketEvent>].
class SocketService {
  io.Socket? _socket;
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  final _taskUpdateController =
      StreamController<TaskSocketEvent>.broadcast();

  Stream<TaskSocketEvent> get taskUpdates => _taskUpdateController.stream;

  String? _token;
  bool _isConnecting = false;
  Completer<void>? _connectCompleter;

  Future<void> connect(String token) async {
    if (_socket?.connected == true) return;
    if (_isConnecting && _connectCompleter != null) {
      return _connectCompleter!.future;
    }

    _token = token;
    if (_connectCompleter != null &&
        !_connectCompleter!.isCompleted) {
      _connectCompleter!.completeError('Connection restarted');
    }
    _connectCompleter = Completer<void>();
    _isConnecting = true;

    _teardownSocket();

    _socket = io.io(
      dotenv.get('WEBSOCKET_URL'),
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .enableReconnection()
          .setReconnectionAttempts(10)
          .setReconnectionDelay(2000)
          .setReconnectionDelayMax(10000)
          .build(),
    );

    _socket!.onConnect((_) {
      _isConnecting = false;
      if (!_connectCompleter!.isCompleted) {
        _connectCompleter!.complete();
      }
    });

    _socket!.onConnectError((error) {
      _isConnecting = false;
      if (!_connectCompleter!.isCompleted) {
        _connectCompleter!.completeError('Failed to connect to socket');
      }
    });

    _socket!.onError((error) {
      _isConnecting = false;
      if (!_connectCompleter!.isCompleted) {
        _connectCompleter!.completeError('Failed to connect to socket');
      }
    });

    _socket!.onDisconnect((_) {
      _isConnecting = false;
    });

    _socket!.on('task.updated', (data) {
      final payload = _asMap(data);
      if (payload == null) return;
      _taskUpdateController.add(TaskSocketUpdated(payload));
    });

    _socket!.on('task.created', (data) {
      final payload = _asMap(data);
      if (payload == null) return;
      _taskUpdateController.add(TaskSocketCreated(payload));
    });

    _socket!.on('task.deleted', (data) {
      final payload = _asMap(data);
      if (payload == null) return;
      _taskUpdateController.add(TaskSocketDeleted(payload));
    });

    _socket!.connect();

    return _connectCompleter!.future.timeout(
      const Duration(seconds: 12),
      onTimeout: () {
        _isConnecting = false;
        throw TimeoutException('Socket connection timed out');
      },
    );
  }

  void emit(String event, Map<String, Object?> data) {
    _socket?.emit(event, data);
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  void disconnect() {
    _isConnecting = false;
    _teardownSocket();
  }

  void _teardownSocket() {
    _socket?.clearListeners();
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  void dispose() {
    _taskUpdateController.close();
  }
}