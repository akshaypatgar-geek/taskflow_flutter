import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  NetworkService._internal();

  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() {
    return _instance;
  }
  final InternetConnection _connection = InternetConnection();
  StreamSubscription<InternetStatus>? _subscription;

  bool wasDisconnected = false;

  void startListening({
    required void Function() onConnected,
  }) {
    _subscription = _connection.onStatusChange.listen((status) {
      
      if (status == InternetStatus.disconnected) {
        wasDisconnected = true;
      }

      if (status == InternetStatus.connected ) {
       
        wasDisconnected = false;
        onConnected();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}