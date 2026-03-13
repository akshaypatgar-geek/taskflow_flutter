import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket _socket;
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();


  final _taskUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get taskUpdates => _taskUpdateController.stream;

  int _retryCount = 0;
  final int _maxRetry = 2;
  String? _token;

  Future<void> connect(String token) async {
    _token = token;
    final completer = Completer<void>();
    _socket = io.io(
      "http://10.153.0.98:3000",
      // "http://192.168.29.140:3000",//"http://localhost:3000",
      io.OptionBuilder()
          .setTransports(['websocket']) 
          .disableAutoConnect()
          .setAuth({'token': token})
          .enableReconnection()
          .build(),
    );

    _socket.onConnect((_) {
      _retryCount=0;
      if (!completer.isCompleted) completer.complete();
    });

    _socket.onError((er) {
      _tryReconnect();
      if (!completer.isCompleted) {
        completer.completeError("Failed to connect to socket");
      }
    });

    _socket.onDisconnect((r) async {
      _tryReconnect();
    });

    _socket.on('task.updated', (data) {
      _taskUpdateController.add({
        'event': 'UPDATE',
        'data': Map<String, dynamic>.from(data),
      });
    });
    _socket.on('task.created', (data) {
      _taskUpdateController.add({
        'event': 'CREATE',
        'data': Map<String, dynamic>.from(data),
      });
    });
    _socket.on('task.deleted', (data) {
      _taskUpdateController.add({
        'event': 'DELETE',
        'data': Map<String, dynamic>.from(data),
      });
    });

    _socket.connect();
    await completer.future;
  }

  void _tryReconnect() {
    if (_retryCount >= _maxRetry) {
      return;
    }

    _retryCount++;

    Future.delayed(const Duration(seconds: 3), () {
      if (_token != null) {
        connect(_token!);
      }
    });
  }

  void emit(String event, dynamic data) {
    _socket.emit(event, data);
  }

  void disconnect() {
    _socket.disconnect();
  }

  void dispose() {
    _taskUpdateController.close();
  }
}
