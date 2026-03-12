import 'dart:async';
import 'dart:developer';
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

  Future<void> connect(String token) async{
    print("before connecting");
    final completer = Completer<void>();
    _socket = IO.io(
      // "http://10.153.0.98:3000",
      "http://192.168.29.140:3000",//"http://localhost:3000",
      IO.OptionBuilder()
          .setTransports(['websocket']) // required for Flutter
          .disableAutoConnect()
          .setAuth({'token': token})
          .enableReconnection()
          .build(),
    );

    _socket.onConnect((_) {
      print("connected to websocket");
     if(!completer.isCompleted) completer.complete();
    });

    _socket.onError((er) {
      log("error socket :${er.toString()}");
     if(!completer.isCompleted) completer.completeError("Failed to connect to socket");
    });

    _socket.onDisconnect((r) async{
    
    log("disconntected ${r.toString()}");
    
      //  await connect(token);
    });
    /// listen for task updates
    _socket.on('task.updated', (data) {
      log("task.updated $data");
      _taskUpdateController.add({
        'event':'UPDATE',
        'data':Map<String, dynamic>.from(data)
      });
    });
    _socket.on('task.created', (data) {
      print("creation alert $data");
      _taskUpdateController.add({
        'event':'CREATE',
        'data':Map<String, dynamic>.from(data)
      });
    });
    _socket.on('task.deleted', (data) {
      
      _taskUpdateController.add({
        'event':'DELETE',
        'data':Map<String, dynamic>.from(data)
      });
    });

     _socket.connect();
    await completer.future;
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