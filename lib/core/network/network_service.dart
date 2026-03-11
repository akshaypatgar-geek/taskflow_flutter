import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  final InternetConnection _connection = InternetConnection();
  StreamSubscription<InternetStatus>? _subscription;

  // bool _wasDisconnected = false;

  void startListening({
    required void Function() onConnected,
  }) {
    _subscription = _connection.onStatusChange.listen((status) {
      print("listener active :$status");
      // if (status == InternetStatus.disconnected) {
      //   _wasDisconnected = true;
      // }

      if (status == InternetStatus.connected ) {
        print("connected");
        // _wasDisconnected = false;
        onConnected();
      }
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}