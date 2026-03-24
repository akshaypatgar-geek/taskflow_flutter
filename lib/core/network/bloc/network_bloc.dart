import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../network_repository.dart';

part 'network_event.dart';
part 'network_state.dart';

class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  final NetworkRepository repository;
  StreamSubscription? _subscription;

  NetworkBloc({required this.repository}) : super(NetworkInitial()) {
   on<StartNetworkMonitoring>(_startMonitoring);
    on<NetworkStatusChanged>(_onStatusChanged);
  }

  void _startMonitoring(
      StartNetworkMonitoring event,
      Emitter<NetworkState> emit,
      ) {
    _subscription = repository.connectionStream.listen((isConnected) {
      add(NetworkStatusChanged(isConnected));
    });
  }

  void _onStatusChanged(
      NetworkStatusChanged event,
      Emitter<NetworkState> emit,
      ) {
    if (event.isConnected) {
      emit(NetworkOnline());
    } else {
      emit(NetworkOffline());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
