import 'dart:async';

import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

class ConnectivityVanillaPage extends StatefulWidget {
  const ConnectivityVanillaPage({super.key});

  @override
  State<ConnectivityVanillaPage> createState() =>
      _ConnectivityVanillaPageState();
}

class _ConnectivityVanillaPageState extends State<ConnectivityVanillaPage> {
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker();
  bool _isConnected = false;
  String _connectionType = 'Unknown';
  String _lastChecked = 'Not checked yet';
  StreamSubscription<InternetResult>? _subscription;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    await _checkConnection();
    _setupConnectionListener();
  }

  Future<void> _checkConnection() async {
    final result = await _connectionChecker.isInternetConnected;
    setState(() {
      _isConnected = result;
      // _connectionType = result.connectionType.toString().split('.').last;
      // _lastChecked = _formatDateTime(DateTime.now());
    });
  }

  void _setupConnectionListener() {
    _subscription = _connectionChecker.onInternetConnectivityChanged.listen((
      result,
    ) {
      if (mounted) {
        setState(() {
          _isConnected = result.hasInternetAccess;
          _connectionType = result.connectionType.toString().split('.').last;
          _lastChecked = _formatDateTime(DateTime.now());
        });
      }
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vanilla Implementation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildConnectionStatusCard(),
            const SizedBox(height: 20),
            _buildCodeExample(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkConnection,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildConnectionStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  _isConnected ? Icons.wifi : Icons.wifi_off,
                  color: _isConnected ? Colors.green : Colors.red,
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isConnected ? 'Connected' : 'Disconnected',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _isConnected ? Colors.green : Colors.red,
                        ),
                      ),
                      Text('Type: $_connectionType'),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text(
              'Last updated: $_lastChecked',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCodeExample() {
    return const ExpansionTile(
      title: Text('Implementation Code'),
      children: [
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('''
// Initialize checker
final InternetConnectionChecker _connectionChecker = InternetConnectionChecker();

// Check connection manually
final result = await _connectionChecker.checkInternetConnection();

// Listen for changes
_subscription = _connectionChecker.onInternetConnectivityChanged.listen((result) {
  // Update UI
});

// Don't forget to cancel subscription in dispose()
''', style: TextStyle(fontFamily: 'monospace')),
        ),
      ],
    );
  }
}
