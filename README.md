# ExtensionResoft

[![pub package](https://img.shields.io/pub/v/extensionresoft.svg?label=extensionresoft&color=blue)](https://pub.dev/packages/extensionresoft)
[![pub points](https://img.shields.io/pub/points/extensionresoft?logo=dart)](https://pub.dev/packages/extensionresoft/score)
[![Pub Monthly Downloads](https://img.shields.io/pub/dm/extensionresoft?logo=dart&color=yellow)](https://pub.dev/packages/extensionresoft/score)
[![likes](https://img.shields.io/pub/likes/extensionresoft?logo=dart&color=red)](https://pub.dev/packages/extensionresoft/score)
<a href="https://github.com/kenresoft/extensionresoft">![Star on Github](https://img.shields.io/github/stars/kenresoft/extensionresoft.svg?style=flat&logo=github&colorB=deeppink&label=stars)</a>
<a href="https://github.com/Solido/awesome-flutter">![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)</a>
<a href="https://opensource.org/license/bsd-3-clause">![License: BSD](https://img.shields.io/badge/license-BSD_3--Clause-teal.svg)</a>

A comprehensive toolkit of extensions, widgets, and utilities to accelerate Flutter development with less code. ExtensionResoft optimizes common tasks, enhances UI components, and provides robust architecture patterns.

## Features

### 📝 Enhanced Text/Form Field Input
Build sophisticated form fields with extensive customization:

- **CustomTextField**: A highly customizable text input field with validation, dropdown support, and accessibility features
- **Validation System**: Built-in validation with error, warning, and info severity levels
- **Password Visibility**: Configurable password visibility toggle with custom icons
- **Dropdown Support**: Seamless integration with dropdown menus
- **Accessibility**: Comprehensive semantics and validation announcements
- **Performance Optimized**: Efficient state management and decoration caching
- **Theming Support**: Automatic light/dark mode adaptation
- **Feedback Widget**: Customizable validation messages with icons and animations

### 🌐 Internet Connectivity Management

Detect and respond to network changes reliably:

- **Real-time Monitoring**: Observe detailed connectivity state changes through streams
- **Granular Control**: Monitor specific connectivity aspects with dedicated streams
- **Simplified API**: Check network status with straightforward methods
- **Resilient Applications**: Build offline-ready features with minimal effort

### 🖼️ Advanced Image Handling

Create robust image components with minimal effort:

- **Multi-source Support**: Handle network URLs, asset paths, and file objects through a unified API
- **AppImage**: Rectangular images with custom border radius, intelligent error handling, and fallbacks
- **AppCircleImage**: Circular avatar images with placeholder and error states
- **Performance Optimized**: Device pixel ratio-aware caching for memory efficiency
- **Decoration Support**: Use as BoxDecoration background images easily

### 🎭 Animation Utilities
Create smooth, performant animations with minimal code:

- **AnimatedFadeScale**: Combined fade and scale animation with configurable timing and curves
    - Customizable start/end scales
    - Optional delay before animation
    - Manual animation control via `value` parameter
    - Material transparency support

- **FadeSlideTransition**: High-performance view transitions with fade and slide effects
    - Smooth content transitions with queuing support
    - Configurable slide direction and distance
    - Key-based transition triggering
    - Optimized for rapid content changes
    - Predefined fast/slow duration presets

### 🔐 Secure PIN Authentication UI

Build secure user authentication flows:

- **PinEntry Widget**: Customizable PIN entry with multiple security configurations
- **Visual Customization**: Style input fields and keyboard components separately
- **Validation Support**: Custom handlers for completion and validation events

### 🧰 UI Extension Toolkit

Write less code for common UI patterns:

- **Spacing Extensions**: Clean spacer syntax with both method and getter options
- **Custom Cards**: Create styled cards with simple radius-based extensions
- **Text Styling**: Format text with fluent extensions for improved readability
- **Image Path Extensions**: Convert asset paths to image widgets directly

### 🧠 Logic & Functional Extensions

Enhance code clarity and maintenance:

- **Conditional Functions**: Widget-friendly alternatives to ternary operators
- **Path Extensions**: Apply transformations to values with clean syntax
- **Value Management**: Robust value retrieval with fallback handling

### 📦 Storage Utilities

Manage persistent data efficiently:

- **SharedPreferencesService**: Type-safe storage for app settings and user preferences
- **Support for Multiple Types**: Store and retrieve booleans, strings, integers, and doubles

## Getting Started

### Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  extensionresoft: ^1.2.1
```

Then run:

```bash
flutter pub get
```

### Basic Usage

Import the package:

```dart
import 'package:extensionresoft/extensionresoft.dart';
```

## Usage Examples

### Enhanced Text Input

```dart
    // Password field with visibility toggle
    CustomTextField(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      labelText: 'Password',
      isPassword: true,
      passwordVisibilityConfig: PasswordVisibilityConfig(
        iconSize: 22,
        visibilityOnTooltip: 'Hide password',
        visibilityOffTooltip: 'Show password',
      ),
    );

    // Dropdown field
    CustomTextField<int>(
      labelText: 'Age Group',
      items: [
        DropdownMenuItem(value: 1, child: Text('Under 18')),
        DropdownMenuItem(value: 2, child: Text('18-25')),
        DropdownMenuItem(value: 3, child: Text('26-35')),
      ],
      onDropdownChanged: (value) {
        print('Selected age group: $value');
      },
    );

    // Styled text field with custom feedback
    CustomTextField(
      labelText: 'Email',
      hintText: 'your@email.com',
      keyboardType: TextInputType.emailAddress,
      borderRadius: BorderRadius.circular(12),
      fillColor: Colors.grey[100],
      borderColor: Colors.blueGrey,
      focusColor: Colors.blue,
      errorStyle: TextStyle(color: Colors.red[800]),
      warningStyle: TextStyle(color: Colors.orange[800]),
      helperStyle: TextStyle(color: Colors.grey),
      helperText: 'Enter a valid email address',
      feedbackShowIcons: true,
      feedbackPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );

    // Field with validation controller integration
    final validationController = ValidationController();

    // Can also be used for multiple fields wrapped in a `Form`.
    CustomTextField(
      labelText: 'Order Number',
      validationController: validationController,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required field';
        if (!RegExp(r'^ORD-\d{4}$').hasMatch(value)) {
          return 'Format: ORD-1234';
        }
        return null;
      },
    );

    // Later in your code
    if (validationController.validate()) {
      // All fields valid
    }
```

### Internet Connectivity

```dart
    // Create a checker instance
    final connectionChecker = InternetConnectionChecker();
    
    // Check current connection status
    final isConnected = await connectionChecker.isInternetConnected;
    print('Internet connected: $isConnected');
    
    // Listen to detailed connectivity changes
    connectionChecker.onInternetConnectivityChanged.listen((result) {
      print('Connection Status: ${result.hasInternetAccess}');
      print('Connection Type: ${result.connectionType}');
      
      // Update UI based on connectivity
      if (result.hasInternetAccess) {
        // Load online data
      } else {
        // Show offline mode UI
      }
    });
    
    // Simplified boolean stream for quick status checks
    connectionChecker.onIsInternetConnected.listen((isConnected) {
      print('Internet status changed: $isConnected');
    });
```

### Image Handling

```dart
    // Network image with fallback and border radius
    AppImage(
      'https://example.com/profile.jpg',
      width: 150,
      height: 150,
      fit: BoxFit.cover,
      borderRadius: BorderRadius.circular(8),
      backgroundColor: Colors.grey[200],
      errorWidget: Icon(Icons.broken_image),
      fallbackImage: 'assets/default_image.png',
    )
    
    // Circle avatar from network or asset
    AppCircleImage(
      'assets/profile_photo.jpg', // or network URL or File object
      radius: 40,
      fit: BoxFit.cover,
      placeholder: CircularProgressIndicator(strokeWidth: 2),
      errorWidget: Icon(Icons.person),
    )
    
    // As decoration image
    Container(
      decoration: BoxDecoration(
        image: AppImage('https://example.com/bg.jpg')
            .toDecorationImage(
          decorationFit: BoxFit.cover,
          fallbackImage: 'assets/default_bg.png',
        ),
      ),
    )
    
    // Path-based image extensions
    'assets/image.png'.img(width: 100, height: 100)
    'assets/avatar.png'.circleImage(fit: BoxFit.cover)
```
### Animation Utilities

```dart
    // Basic fade and scale animation
    AnimatedFadeScale(
      duration: Duration(milliseconds: 500),
      child: Container(
        width: 200,
        height: 200,
        color: Colors.blue,
        child: Center(child: Text('Hello!')),
      ),
    );

    // Staggered animations with delay
    Column(
      children: [
        AnimatedFadeScale(
          delay: Duration(milliseconds: 100),
          child: Card(child: /*...*/),
        ),
        AnimatedFadeScale(
          delay: Duration(milliseconds: 200),
          child: Card(child: /*...*/),
        ),
        AnimatedFadeScale(
          delay: Duration(milliseconds: 300),
          child: Card(child: /*...*/),
        ),
      ],
    );

    // Manual animation control
    double _animationValue = 0.0;

    AnimatedFadeScale(
      value: _animationValue,
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            _animationValue = _animationValue == 0.0 ? 1.0 : 0.0;
          });
        },
      ),
    );

    // FadeSlideTransition with key-based triggering
    final _transitionKey = UniqueKey();

    FadeSlideTransition(
      transitionKey: _transitionKey,
      duration: Duration(milliseconds: 400),
      initialSlideOffset: Offset(0, 0.1), // Slide up from bottom
      child: _buildContentWidget(),
    );

    // Later when content needs to change
    setState(() {
      _transitionKey = UniqueKey(); // Triggers new transition
    });

    // Using predefined durations
    FadeSlideTransition.fast(
      child: NotificationBadge(count: 5),
    );

    FadeSlideTransition.slow(
      child: HeroImage(url: imageUrl),
    );

    // Transition with completion callback
    FadeSlideTransition(
      child: ProfileHeader(user: user),
      onTransitionComplete: () {
        print('Transition finished!');
      },
    );
```

### PIN Authentication

```dart
    PinEntry(
      pinLength: 6,
      onInputComplete: (pin) {
        // Handle PIN validation
      },
      inputFieldConfiguration: InputFieldConfiguration(
        obscureText: true,
        fieldFillColor: Colors.grey[200],
        focusedBorderColor: Colors.blue,
      ),
      keyboardConfiguration: KeyboardConfiguration(
        keyBackgroundColor: Colors.white,
        keyTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    )
```

### UI Extensions

```dart
    // Spacing utilities
    16.spaceX()  // SizedBox(width: 16)
    24.spaceY()  // SizedBox(height: 24)
    32.spaceXY() // SizedBox(width: 32, height: 32)
    
    // Getters for even cleaner code
    20.spX  // SizedBox(width: 20)
    30.spY  // SizedBox(height: 30)
    
    // Custom card with styling
    12.radius(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Text('Rounded Card Example'),
      ),
      elevation: 2,
      color: Colors.blue[50],
      strokeColor: Colors.black12,
    )
    
    // Text styling
    'Hello Flutter'.edit(
      textStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
      textAlign: TextAlign.center,
    )
```

### Logic & Functional Extensions

```dart
    // Path extension to transform values
    final doubled = 16.p((n) => n * 2);  // 32
    
    // Widget-friendly conditional logic
    final result = condition(isActive, 'Active', 'Inactive');
    
    // Function-based conditionals (lazy evaluation)
    final message = conditionFunction(
      hasPermission,
      () => 'Access granted',
      () => 'Access denied: ${getErrorMessage()}',
    );
    
    // Safe value retrieval with fallback
    final displayName = get(user.name, 'Guest User');
```

### Shared Preferences

```dart
    // Initialize service
    await SharedPreferencesService.init();
    
    // Store values
    await SharedPreferencesService.setBool('isDarkMode', true);
    await SharedPreferencesService.setString('username', 'flutter_dev');
    
    // Retrieve values
    final isDarkMode = SharedPreferencesService.getBool('isDarkMode');
    final username = SharedPreferencesService.getString('username', 'guest');
```

## Advanced Usage

See the [API Reference](https://pub.dev/documentation/extensionresoft/latest/) for comprehensive documentation of all available extensions and utilities.

## Migration from 1.0.0 to 1.1.0

While version 1.1.0 maintains backward compatibility, we recommend the following changes:

- Replace `assetFallback` with `fallbackImage` parameter in image widgets for improved naming consistency
- Take advantage of the new `File` object support in image widgets
- Utilize new `borderRadius` and `backgroundColor` parameters for enhanced customization

## Screenshots

(None applicable in this current release)

[//]: # (Include any relevant screenshots or GIFs showcasing the extensions in action &#40;if applicable&#41;.)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/amazing-feature`)
3. Commit your Changes (`git commit -m 'Add some amazing feature'`)
4. Push to the Branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](LICENSE) file for details.
