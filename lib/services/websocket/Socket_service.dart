import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;
  static final SocketService _instance = SocketService._internal();

  factory SocketService() {
    return _instance;
  }

  SocketService._internal();

  final _taskUpdateController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get taskUpdates => _taskUpdateController.stream;

  void connect(String token) async{
    
    _socket = IO.io(
      "http://localhost:3000",
      IO.OptionBuilder()
          .setTransports(['websocket']) // required for Flutter
          .disableAutoConnect()
          .setAuth({'token': token})
          .enableReconnection()
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      print("Socket connected");
    });

    _socket.onDisconnect((_) {
      print("Socket disconnected");
    });
    /// listen for task updates
    _socket.on('task.updated', (data) {
      print("taske :$data");
      _taskUpdateController.add({
        'event':'UPDATE',
        'data':Map<String, dynamic>.from(data)
      });
    });
    _socket.on('task.created', (data) {
      print("taske :$data");
      _taskUpdateController.add({
        'event':'CREATE',
        'data':Map<String, dynamic>.from(data)
      });
    });
    _socket.on('task.deleted', (data) {
      print("taske :$data");
      _taskUpdateController.add({
        'event':'DELETE',
        'data':Map<String, dynamic>.from(data)
      });
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