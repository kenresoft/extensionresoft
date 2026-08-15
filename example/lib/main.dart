import 'package:flutter/material.dart';
import 'package:extensionresoft/extensionresoft.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Extensionresoft Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key});

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  RangeValues _currentRange = const RangeValues(20, 80);
  double _rating = 3.5;
  final _validationController = ValidationController();
  UniqueKey _transitionKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ExtensionResoft Examples'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('📝 Enhanced Text Fields'),
            _buildTextFieldSection(),
            _buildSectionTitle('🎚️ Interactive UI Components'),
            _buildInteractiveSection(),
            _buildSectionTitle('🎭 Animation Utilities'),
            _buildAnimationSection(),
            _buildSectionTitle('🔐 PIN Authentication'),
            _buildPinAuthenticationSection(),
            _buildSectionTitle('🖼️ Image Utilities'),
            _buildImageExamplesSection(),
            _buildSectionTitle('🌐 Internet Connectivity'),
            _buildConnectivityExamplesSection(),
            _buildSectionTitle('🧰 UI Utility Extensions'),
            _buildUiExtensionsSection(),
            _buildSectionTitle('🧠 Functional & Logic'),
            _buildFunctionalSection(),
          ],
        ),
      ),
    );
  }

  // Section Header Builder
  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
          ],
        ),
      );

  // ───────────────────────────────────────────────
  // 📝 TEXT FIELD DEMO
  // ───────────────────────────────────────────────
  Widget _buildTextFieldSection() {
    return Column(
      children: [
        _buildExample(
          'Consistent Height (Height: 50)',
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextField(
                  height: 50,
                  labelText: 'Matching Height',
                  hintText: 'Aligns with the button',
                  prefixIcon: const Icon(Icons.height),
                ),
              ),
              12.spaceX(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Button'),
              ),
            ],
          ),
        ),
        CustomTextField(
          labelText: 'Username',
          hintText: 'Enter your username',
          prefixIcon: const Icon(Icons.person),
          validationController: _validationController,
          validator: (value) {
            if (value == null || value.isEmpty) return 'Username is required';
            if (value.length < 3) return 'Too short';
            return null;
          },
        ),
        16.spY,
        CustomTextField(
          labelText: 'Password',
          isPassword: true,
          prefixIcon: const Icon(Icons.lock),
          passwordVisibilityConfig: const PasswordVisibilityConfig(
            visibilityOnTooltip: 'Hide',
            visibilityOffTooltip: 'Show',
          ),
        ),
        16.spY,
        CustomTextField<String>(
          labelText: 'Select Category',
          items: const [
            DropdownMenuItem(value: 'tech', child: Text('Technology')),
            DropdownMenuItem(value: 'health', child: Text('Health')),
            DropdownMenuItem(value: 'finance', child: Text('Finance')),
          ],
          onDropdownChanged: (value) => debugPrint('Selected: $value'),
        ),
        16.spY,
        ElevatedButton(
          onPressed: () {
            if (_validationController.validate()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Validation Passed!')),
              );
            }
          },
          child: const Text('Validate Form'),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🎚️ INTERACTIVE COMPONENTS
  // ───────────────────────────────────────────────
  Widget _buildInteractiveSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExample(
          'Custom Range Slider (${_currentRange.start.round()} - ${_currentRange.end.round()})',
          CustomRangeSlider(
            values: _currentRange,
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: (values) => setState(() => _currentRange = values),
            customTheme: CustomRangeSliderTheme(
              activeTrackColor: Colors.deepPurple,
              thumbColor: Colors.white,
              thumbBorderColor: Colors.deepPurple,
            ),
          ),
        ),
        _buildExample(
          'Custom Rating Bar ($_rating)',
          CustomRatingBar(
            initialRating: _rating,
            allowHalfRating: true,
            showRatingText: true,
            onRatingChanged: (rating) => setState(() => _rating = rating),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🎭 ANIMATION UTILITIES
  // ───────────────────────────────────────────────
  Widget _buildAnimationSection() {
    return Column(
      children: [
        FadeSlideTransition(
          transitionKey: _transitionKey,
          child: Card(
            color: Colors.deepPurple.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Animated Content Block',
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
          ),
        ),
        12.spY,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _transitionKey = UniqueKey()),
              child: const Text('Trigger Transition'),
            ),
            12.spaceX(),
            const AnimatedFadeScale(
              child: CircleAvatar(child: Icon(Icons.star)),
            ),
          ],
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🔐 PIN ENTRY DEMO
  // ───────────────────────────────────────────────
  Widget _buildPinAuthenticationSection() {
    return PinEntry(
      pinLength: 4,
      onInputComplete: (pin) => debugPrint('PIN: $pin'),
      inputFieldConfiguration: InputFieldConfiguration(
        fieldFillColor: Colors.grey.shade200,
        focusedBorderColor: Colors.deepPurple,
      ),
    );
  }

  // ───────────────────────────────────────────────
  // 🖼️ IMAGE EXTENSIONS
  // ───────────────────────────────────────────────
  Widget _buildImageExamplesSection() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        const AppImage(
          'https://picsum.photos/200',
          width: 100,
          height: 100,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          fit: BoxFit.cover,
        ),
        const AppCircleImage(
          'https://picsum.photos/100',
          radius: 50,
        ),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            image: const AppImage('https://picsum.photos/150').toDecorationImage(),
          ),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🌐 CONNECTIVITY MONITORING
  // ───────────────────────────────────────────────
  Widget _buildConnectivityExamplesSection() {
    return const _ConnectivityDemoWidget();
  }

  // ───────────────────────────────────────────────
  // 🧰 UI EXTENSIONS
  // ───────────────────────────────────────────────
  Widget _buildUiExtensionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExample(
          'Spacing & Cards',
          Row(
            children: [
              const Text('A'),
              12.spaceX(),
              8.radius(
                color: Colors.amber.shade100,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text('Card'),
                ),
              ),
              12.spX,
              const Text('B'),
            ],
          ),
        ),
        'Fluent Text Styling'.edit(
          textStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🧠 FUNCTIONAL & LOGIC
  // ───────────────────────────────────────────────
  Widget _buildFunctionalSection() {
    // Either Example
    final Either<String, int> result = Either.tryCatch(
      (e, s) => 'Error',
      () => int.parse('123'),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Either result: ${result.fold((l) => l, (r) => r.toString())}'),
        8.spY,
        Text('Condition: ${condition(true, "Yes", "No")}'),
        8.spY,
        Text('Path Extension (10.p): ${10.p((n) => n * 5)}'),
      ],
    );
  }

  // ───────────────────────────────────────────────
  // 🔧 Reusable Builders
  // ───────────────────────────────────────────────
  Widget _buildExample(String title, Widget widget) {
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
}

// ───────────────────────────────────────────────
// CONNECTIVITY DEMO WIDGET
// ───────────────────────────────────────────────
class _ConnectivityDemoWidget extends StatefulWidget {
  const _ConnectivityDemoWidget();

  @override
  State<_ConnectivityDemoWidget> createState() => _ConnectivityDemoWidgetState();
}

class _ConnectivityDemoWidgetState extends State<_ConnectivityDemoWidget> {
  final _checker = InternetConnectionChecker();
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _checker.onIsInternetConnected.listen((connected) {
      if (mounted) setState(() => _isConnected = connected);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        _isConnected ? Icons.cloud_done : Icons.cloud_off,
        color: _isConnected ? Colors.green : Colors.red,
      ),
      title: Text(_isConnected ? 'Online' : 'Offline'),
      subtitle: const Text('Real-time connectivity monitoring'),
      tileColor: Colors.grey.shade100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
