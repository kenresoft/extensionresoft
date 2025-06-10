import 'package:flutter/material.dart';

import 'views/connectivity_bloc_page.dart';
import 'views/connectivity_vanilla_page.dart';

class ConnectivityDemoApp extends StatelessWidget {
  const ConnectivityDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Connectivity Demo',
      theme: ThemeData(useMaterial3: true),
      home: const ConnectivityDemoHome(),
    );
  }
}

class ConnectivityDemoHome extends StatelessWidget {
  const ConnectivityDemoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connectivity Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ConnectivityVanillaPage(),
                ),
              ),
              child: const Text('Vanilla Implementation'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ConnectivityBlocPage()),
              ),
              child: const Text('BLoC Implementation'),
            ),
          ],
        ),
      ),
    );
  }
}
