import 'dart:async';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/connectivity_repository.dart';

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
    on<StreamConnectivity>(_onStreamConnectivity);
    on<ConnectivityChanged>(_onConnectivityChanged);
  }

  Future<void> _onCheckConnectivity(
    CheckConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.checkConnection();
    emit(ConnectivityState(isConnected: result));
  }

  Future<void> _onStreamConnectivity(
    StreamConnectivity event,
    Emitter<ConnectivityState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    // Start listening
    _subscription = _repository.connectionStream.listen((result) {
      add(ConnectivityChanged(result));
    });
  }

  void _onConnectivityChanged(
    ConnectivityChanged event,
    Emitter<ConnectivityState> emit,
  ) {
    InternetResult result = event.result;
    emit(ConnectivityState(
      isConnected: result.hasInternetAccess,
      connectionType: result.connectionType.toString().split('.').last,
      lastChecked: _formatDateTime(DateTime.now()),
      isLoading: false,
    ));
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
