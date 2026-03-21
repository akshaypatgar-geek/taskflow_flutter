part of 'network_bloc.dart';

@immutable
sealed class NetworkEvent {}

class StartNetworkMonitoring extends NetworkEvent {}

class NetworkStatusChanged extends NetworkEvent {
  final bool isConnected;

  NetworkStatusChanged(this.isConnected);
}
