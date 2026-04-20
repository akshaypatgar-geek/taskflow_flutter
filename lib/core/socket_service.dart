import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:taskflowapp/core/config/app_config.dart';

import 'socket_events.dart';

/// WebSocket service using Socket.IO. Connects with JWT auth, listens for task
/// CRUD events, and exposes a broadcast [Stream<TaskSocketEvent>].
///
/// A single instance is provided by GetIt ([registerLazySingleton]);
class SocketService {
  io.Socket? _socket;

  SocketService();

  final _taskUpdateController = StreamController<TaskSocketEvent>.broadcast();

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
    if (_connectCompleter != null && !_connectCompleter!.isCompleted) {
      _connectCompleter!.completeError('Connection restarted');
    }
    _connectCompleter = Completer<void>();
    _isConnecting = true;

    _teardownSocket();

    _socket = io.io(
      AppConfig.websocketUrl,
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
      final actualData = (data is List && data.isNotEmpty) ? data[0] : data;
      debugPrint('Websocket task.updated - actualData type: ${actualData.runtimeType}');
      final payload = _asMap(actualData);
      if (payload != null) {
        final event = TaskSocketUpdated(payload);
        debugPrint('Adding event to stream: $event, Type: ${event.runtimeType}');
        _taskUpdateController.add(event);
      }
    });

    _socket!.on('task.created', (data) {
      final actualData = (data is List && data.isNotEmpty) ? data[0] : data;
      debugPrint('Websocket task.created - actualData type: ${actualData.runtimeType}');
      final payload = _asMap(actualData);
      if (payload != null) {
        final event = TaskSocketCreated(payload);
        debugPrint('Adding event to stream: $event, Type: ${event.runtimeType}');
        _taskUpdateController.add(event);
      }
    });

    _socket!.on('task.deleted', (data) {
      final actualData = (data is List && data.isNotEmpty) ? data[0] : data;
      debugPrint('Websocket task.deleted - actualData type: ${actualData.runtimeType}');
      final payload = _asMap(actualData);
      if (payload != null) {
        final event = TaskSocketDeleted(payload);
        debugPrint('Adding event to stream: $event, Type: ${event.runtimeType}');
        _taskUpdateController.add(event);
      }
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
    if (data == null) return null;
    
    // try {
      // 1. If the server sends a JSON string, decode it first
      if (data is String) {
        final decoded = jsonDecode(data);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
        return null;
      }

      // 2. Normalizing from Map
      if (data is Map<String, dynamic>) return data;
      if (data is Map) return Map<String, dynamic>.from(data);
      
      // 3. Web-specific normalization (LegacyJavaScriptObject)
      // This is the most robust way to force a JS object into a Dart Map
      final String encoded = jsonEncode(data);
      final decoded = jsonDecode(encoded);
      if (decoded is Map<String, dynamic>) return decoded;
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    // } catch (e) {
    //   debugPrint('Error converting socket data: $e');
    // }
    return null;
  }

  Map<String, dynamic> sanitizeMap(Map data) {
  final result = <String, dynamic>{};

  data.forEach((key, value) {
    result[key.toString()] = _sanitize(value);
  });

  return result;
}

dynamic _sanitize(dynamic value) {
  if (value is Map) {
    return sanitizeMap(value);
  }

  if (value is List) {
    return value.map(_sanitize).toList();
  }

  return value;
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
