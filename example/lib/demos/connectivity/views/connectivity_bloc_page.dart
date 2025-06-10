import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/connectivity_bloc.dart';
import '../repository/connectivity_repository.dart';

class ConnectivityBlocPage extends StatelessWidget {
  const ConnectivityBlocPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ConnectivityBloc(ConnectivityRepository())..add(StreamConnectivity()),
      child: Scaffold(
        appBar: AppBar(title: const Text('BLoC Implementation')),
        body: const _ConnectivityView(),
        floatingActionButton: const _RefreshButton(),
      ),
    );
  }
}

class _ConnectivityView extends StatelessWidget {
  const _ConnectivityView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
      child: Column(
        children: [
          _buildConnectionStatusCard(),
          const SizedBox(height: 20),
          const _CodeExample(),
        ],
      ),
      ),
    );
  }

  Widget _buildConnectionStatusCard() {
    return BlocBuilder<ConnectivityBloc, ConnectivityState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      )
                    else
                      Icon(
                        state.isConnected ? Icons.wifi : Icons.wifi_off,
                        color: state.isConnected ? Colors.green : Colors.red,
                        size: 40,
                      ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.isConnected ? 'Connected' : 'Disconnected',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: state.isConnected ? Colors.green : Colors.red,
                                ),
                          ),
                          Text('Type: ${state.connectionType}'),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Text(
                  'Last updated: ${state.lastChecked}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        context.read<ConnectivityBloc>().add(CheckConnectivity());
      },
      child: const Icon(Icons.refresh),
    );
  }
}

class _CodeExample extends StatelessWidget {
  const _CodeExample();

  @override
  Widget build(BuildContext context) {
    return const ExpansionTile(
      title: Text('Implementation Code'),
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            '''
// BLoC Events
abstract class ConnectivityEvent {}
class CheckConnectivity extends ConnectivityEvent {}
class ConnectivityChanged extends ConnectivityEvent {
  final ConnectivityResult result;
}

// BLoC State
class ConnectivityState {
  final bool isConnected;
  final String connectionType;
  final String lastChecked;
}

// BLoC Implementation
class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final ConnectivityRepository _repository;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityBloc(this._repository) : super(initialState) {
    on<CheckConnectivity>(_onCheckConnectivity);
    on<ConnectivityChanged>(_onConnectivityChanged);
    
    _subscription = _repository.connectionStream.listen((result) {
      add(ConnectivityChanged(result));
    });
  }
  
  // Handle events...
}
''',
            style: TextStyle(fontFamily: 'monospace'),
          ),
        ),
      ],
    );
  }
}
