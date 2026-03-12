// // import 'dart:async';
// // import 'network_service.dart';

// // class NetworkRepository {
// //   final NetworkService _networkService = NetworkService();

// //   final StreamController<bool> _controller = StreamController.broadcast();

// //   Stream<bool> get connectionStream => _controller.stream;

// //   void startListening() {
// //     _networkService.startListening(
// //       onConnected: () {
// //         _controller.add(true);
// //       },
// //     );
// //   }

// //   void addDisconnected() {
// //     _controller.add(false);
// //   }

// //   void dispose() {
// //     _networkService.dispose();
// //     _controller.close();
// //   }
// // }
// import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// import 'network_service.dart';


// class NetworkRepository {
//   final NetworkService _service;

//   NetworkRepository(this._service);

//   Stream<bool> get connectionStream {
//     return _service.onStatusChange.map((status) {
//       return status == InternetStatus.connected;
//     });
//   }
// }