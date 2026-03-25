import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'socket_events.dart';

/// Singleton WebSocket service using Socket.IO. Connects with JWT auth,
/// listens for task CRUD events, and exposes a broadcast [Stream<TaskSocketEvent>].
class SocketService {
  late io.Socket _socket;
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  final _taskUpdateController =
      StreamController<TaskSocketEvent>.broadcast();

  Stream<TaskSocketEvent> get taskUpdates => _taskUpdateController.stream;

  int _retryCount = 0;
  final int _maxRetry = 2;
  String? _token;

  // ✅ Added: persistent completer
  Completer<void>? _connectCompleter;

  Future<void> connect(String token) async {
    _token = token;

    // ✅ Cancel previous pending completer (important)
    if (_connectCompleter != null &&
        !_connectCompleter!.isCompleted) {
      _connectCompleter!
          .completeError("Cancelled due to reconnect");
    }

    _connectCompleter = Completer<void>();

    _socket = io.io(
      dotenv.get('WEBSOCKET_URL'),
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': token})
          .enableReconnection()
          .build(),
    );

    _socket.onConnect((_) {
      _retryCount = 0;
      if (!_connectCompleter!.isCompleted) {
        _connectCompleter!.complete();
      }
    });

    _socket.onError((er) {
      _tryReconnect();
      if (!_connectCompleter!.isCompleted) {
        _connectCompleter!
            .completeError("Failed to connect to socket");
      }
    });

    _socket.onDisconnect((r) async {
      _tryReconnect();
    });

    _socket.on('task.updated', (data) {
      final payload = _asMap(data);
      if (payload == null) return;
      _taskUpdateController.add(TaskSocketUpdated(payload));
    });

    _socket.on('task.created', (data) {
      final payload = _asMap(data);
      if (payload == null) return;
      _taskUpdateController.add(TaskSocketCreated(payload));
    });

    _socket.on('task.deleted', (data) {
      final payload = _asMap(data);
      if (payload == null) return;
      _taskUpdateController.add(TaskSocketDeleted(payload));
    });

    _socket.connect();

    return _connectCompleter!.future;
  }

  void _tryReconnect() {
    if (_retryCount >= _maxRetry) {
      return;
    }

    _retryCount++;

    Future.delayed(const Duration(seconds: 3), () {
      if (_token != null) {
        // ✅ Ensure previous completer is resolved before reconnect
        if (_connectCompleter != null &&
            !_connectCompleter!.isCompleted) {
          _connectCompleter!
              .completeError("Reconnect attempt started");
        }

        connect(_token!);
      }
    });
  }

  void emit(String event, Map<String, Object?> data) {
    _socket.emit(event, data);
  }

  Map<String, dynamic>? _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    return null;
  }

  void disconnect() {
    _socket.disconnect();
  }

  void dispose() {
    _taskUpdateController.close();
  }
}