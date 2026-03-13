
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import 'network_service.dart';


class NetworkRepository {
  final NetworkService service;

  NetworkRepository({required this.service});

  Stream<bool> get connectionStream {
    return service.onStatusChange.map((status) {
      return status == InternetStatus.connected;
    });
  }
}