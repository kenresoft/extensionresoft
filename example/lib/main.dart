import 'package:flutter/material.dart';
import 'package:extensionresoft/extensionresoft.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Extensionresoft Demo',
      theme: ThemeData(useMaterial3: true),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExtensionResoft Examples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('🔐 PIN Authentication'),
            _buildPinAuthenticationSection(),
            _buildSectionTitle('🖼️ Image Utilities'),
            _buildImageExamplesSection(),
            _buildSectionTitle('🌐 Internet Connectivity'),
            _buildConnectivityExamplesSection(),
            _buildSectionTitle('🧰 UI Utility Extensions'),
            _buildUiExtensionsSection(),
            _buildSectionTitle('🧠 Logic and Functional Utilities'),
            _buildFunctionalExamplesSection(),
            _buildSectionTitle('🔁 Conditional Logic (Widget-friendly)'),
            _buildConditionalExamplesSection(),
          ],
        ),
      ),
    );
  }

  // Section Header Builder
  static Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );

  // ───────────────────────────────────────────────
  // 🔐 PIN ENTRY DEMO
  // ───────────────────────────────────────────────
  static Widget _buildPinAuthenticationSection() {
    return const PinEntry(
      pinLength: 6,
      onInputComplete: _handlePinEntered,
      inputFieldConfiguration: InputFieldConfiguration(
        obscureText: true,
        fieldFillColor: Colors.grey,
        focusedBorderColor: Colors.blueAccent,
      ),
      keyboardConfiguration: KeyboardConfiguration(
        keyBackgroundColor: Colors.white,
        keyTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ───────────────────────────────────────────────
  // 🖼️ IMAGE EXTENSIONS
  // ───────────────────────────────────────────────
  static Widget _buildImageExamplesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExample(
          'Network Image with Fallback',
          const AppImage(
            'https://example.com/profile.jpg',
            width: 150,
            height: 150,
            fit: BoxFit.cover,
            errorWidget: FlutterLogo(),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
        _buildExample(
          'Circular Avatar Image',
          const AppCircleImage(
            'assets/profile_photo.jpg',
            radius: 40,
            placeholder: CircularProgressIndicator(strokeWidth: 2),
            errorWidget: Icon(Icons.person, size: 40),
          ),
        ),
        _buildExample(
          'Background Image Decoration',
          Container(
            width: 200,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: const AppImage(
                '',
              ).toDecorationImage(decorationFit: BoxFit.cover),
            ),
          ),
        ),
        _buildExample(
          'Image from Asset Path',
          Row(
            children: [
              'assets/image.png'.img(
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        _buildExample(
          'Circle Image with Opacity',
          'assets/avatar.png'.circleImage(fit: BoxFit.cover),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🌐 CONNECTIVITY MONITORING
  // ───────────────────────────────────────────────
  static Widget _buildConnectivityExamplesSection() {
    return _ConnectivityDemoWidget();
  }

  // ───────────────────────────────────────────────
  // 🧰 UI EXTENSIONS
  // ───────────────────────────────────────────────
  static Widget _buildUiExtensionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExample(
          'Spacing Utility',
          Row(
            children: [
              16.spaceX(),
              const Text('Item A'),
              24.spaceX(),
              const Text('Item B'),
            ],
          ),
        ),
        _buildExample(
          'Custom Card (rounded corners, elevation, color, stroke)',
          12.radius(
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Rounded Card Example'),
            ),
            elevation: 2,
            color: Colors.blue[50],
            strokeColor: Colors.black12,
            shadowColor: Colors.grey,
          ),
        ),
        _buildExample(
          'Styled Text using edit()',
          'Hello Flutter'.edit(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🧠 FUNCTIONAL EXTENSIONS
  // ───────────────────────────────────────────────
  static Widget _buildFunctionalExamplesSection() {
    final doubled = 16.p((n) => n * 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExample(
          'Apply Function to Value (Path Extension)',
          Text('16.p((n) => n * 2) = $doubled'),
        ),
        _buildExample(
          'Get Value or Default',
          Text(get('Existing Value', 'Fallback Value')),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🔁 CONDITIONAL UTILITIES
  // ───────────────────────────────────────────────
  static Widget _buildConditionalExamplesSection() {
    final staticCondition = condition(true, 'Yes', 'No');
    final dynamicCondition = conditionFunction(
      true,
      () => 'Evaluated True Case',
      () => 'Evaluated False Case',
    );
    final widgetConditional = condition(
      true,
      const Icon(Icons.check, color: Colors.green),
      const Icon(Icons.close, color: Colors.red),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '`condition()` can replace ternary `? :` and is widget-friendly.',
        ),
        const SizedBox(height: 8),
        _buildExample(
          'condition(true, "Yes", "No")',
          Text('Result: $staticCondition'),
        ),
        _buildExample(
          'conditionFunction(true, () => ..., () => ...)',
          Text('Result: $dynamicCondition'),
        ),
        _buildExample('Widget Conditional Result', widgetConditional),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🔧 Reusable Builders
  // ───────────────────────────────────────────────
  static Widget _buildExample(String title, Widget widget) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          widget,
        ],
      ),
    );
  }

  static void _handlePinEntered(String pin) {
    debugPrint('PIN entered: $pin');
    // Handle authentication logic here
  }
}

// ───────────────────────────────────────────────
// CONNECTIVITY DEMO WIDGET
// ───────────────────────────────────────────────
class _ConnectivityDemoWidget extends StatefulWidget {
  @override
  State<_ConnectivityDemoWidget> createState() =>
      _ConnectivityDemoWidgetState();
}

class _ConnectivityDemoWidgetState extends State<_ConnectivityDemoWidget> {
  final InternetConnectionChecker _connectionChecker =
      InternetConnectionChecker();
  bool _isConnected = false;
  String _connectionType = 'Unknown';
  String _lastChecked = 'Not checked yet';

  @override
  void initState() {
    super.initState();
    _checkConnection();
    _setupConnectionListener();
  }

  Future<void> _checkConnection() async {
    final isConnected = await _connectionChecker.isInternetConnected;
    setState(() {
      _isConnected = isConnected;
      _lastChecked = DateTime.now().toString().substring(0, 19);
    });
  }

  void _setupConnectionListener() {
    _connectionChecker.onInternetConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result.hasInternetAccess;
        _connectionType = result.connectionType.toString().split('.').last;
        _lastChecked = DateTime.now().toString().substring(0, 19);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _isConnected ? Icons.wifi : Icons.wifi_off,
              color: _isConnected ? Colors.green : Colors.red,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isConnected
                        ? 'Internet Available'
                        : 'No Internet Connection',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    'Connection Type: $_connectionType',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Last Updated: $_lastChecked',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: _checkConnection,
              child: const Text('Check Now'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCodeExample(),
      ],
    );
  }

  Widget _buildCodeExample() {
    return 12.radius(
      child: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.grey[100],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Usage Example:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'final checker = InternetConnectionChecker();\n'
              'checker.onIsInternetConnected.listen((isConnected) {\n'
              '  // Update UI based on connectivity\n'
              '});',
              style: TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 8),
            const Text(
              'Future<void> performAction() async {\n'
              '  if (await checker.isInternetConnected) {\n'
              '    // Perform online-dependent action\n'
              '  } else {\n'
              '    // Show offline message\n'
              '  }\n'
              '}',
              style: TextStyle(fontFamily: 'monospace'),
            ),
          ],
        ),
      ),
    );
  }
}
