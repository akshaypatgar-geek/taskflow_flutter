

import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkService {
  final InternetConnection _connection = InternetConnection();

  Stream<InternetStatus> get onStatusChange => _connection.onStatusChange;
}