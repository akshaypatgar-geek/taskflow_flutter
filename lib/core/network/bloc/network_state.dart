part of 'network_bloc.dart';

@immutable
sealed class NetworkState {}

class NetworkInitial extends NetworkState {}

class NetworkOnline extends NetworkState {}

class NetworkOffline extends NetworkState {}
