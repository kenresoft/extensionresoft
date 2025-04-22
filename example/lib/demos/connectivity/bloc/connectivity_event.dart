// connectivity/bloc/connectivity_event.dart
part of 'connectivity_bloc.dart';

sealed class ConnectivityEvent {
  const ConnectivityEvent();
}

class CheckConnectivity extends ConnectivityEvent {}

class ConnectivityChanged extends ConnectivityEvent {
  final InternetResult result;

  const ConnectivityChanged(this.result);
}
