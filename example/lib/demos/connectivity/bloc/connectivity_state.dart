part of 'connectivity_bloc.dart';

class ConnectivityState {
  final bool isConnected;
  final String? connectionType;
  final String? lastChecked;
  final bool isLoading;

  const ConnectivityState({
    required this.isConnected,
    this.connectionType,
    this.lastChecked,
    this.isLoading = false,
  });

  ConnectivityState copyWith({
    bool? isConnected,
    String? connectionType,
    String? lastChecked,
    bool? isLoading,
  }) {
    return ConnectivityState(
      isConnected: isConnected ?? this.isConnected,
      connectionType: connectionType ?? this.connectionType,
      lastChecked: lastChecked ?? this.lastChecked,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
