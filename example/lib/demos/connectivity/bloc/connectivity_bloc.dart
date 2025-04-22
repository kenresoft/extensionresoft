// connectivity/bloc/connectivity_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:extensionresoft/extensionresoft.dart';
import 'connectivity_repository.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityRepository _repository;
  StreamSubscription<InternetResult>? _subscription;

  ConnectivityBloc(this._repository)
      : super(const ConnectivityState(
    isConnected: false,
    connectionType: 'Unknown',
    lastChecked: 'Never',
  )) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityChanged>(_onConnectivityChanged);

    // Start listening when bloc is created
    _subscription = _repository.connectionStream.listen((result) {
      add(ConnectivityChanged(result));
    });
  }

  Future<void> _onCheckConnectivity(
      CheckConnectivity event,
      Emitter<ConnectivityState> emit,
      ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkConnection();
    emit(ConnectivityState(isConnected: result, connectionType: connectionType, lastChecked: lastChecked));
  }

  void _onConnectivityChanged(
      ConnectivityChanged event,
      Emitter<ConnectivityState> emit,
      ) {
    emit(_mapResultToState(event.result));
  }

  ConnectivityState _mapResultToState(InternetResult result) {
    return ConnectivityState(
      isConnected: result.hasInternetAccess,
      connectionType: result.connectionType.toString().split('.').last,
      lastChecked: _formatDateTime(DateTime.now()),
      isLoading: false,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}