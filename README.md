<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

# extensionresoft

[![pub package](https://img.shields.io/pub/v/extensionresoft.svg?label=extensionresoft&color=blue)](https://pub.dev/packages/extensionresoft)
[![pub points](https://img.shields.io/pub/points/extensionresoft?logo=dart)](https://pub.dev/packages/extensionresoft/score)
[![popularity](https://img.shields.io/pub/popularity/extensionresoft?logo=dart&color=yellow)](https://pub.dev/packages/extensionresoft/score)
[![likes](https://img.shields.io/pub/likes/extensionresoft?logo=dart&color=red)](https://pub.dev/packages/extensionresoft/score)
<a href="https://github.com/kenresoft/extensionresoft">![Star on Github](https://img.shields.io/github/stars/kenresoft/extensionresoft.svg?style=flat&logo=github&colorB=deeppink&label=stars)</a>
<a href="https://github.com/Solido/awesome-flutter">![Awesome Flutter](https://img.shields.io/badge/Awesome-Flutter-blue.svg?longCache=true&style=flat-square)</a>
<a href="https://opensource.org/license/bsd-3-clause">![License: BSD](https://img.shields.io/badge/license-BSD_3--Clause-teal.svg)</a>

A comprehensive collection of reusable widgets, utilities, and extensions designed to streamline your Flutter development process.
**Ideal for:** Faster development, streamlined app development, building secure login screens, and managing app settings.

## Table of Contents

- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [Examples](#examples)
- [Tests](#tests)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

## Installation

To use the extensionresoft library in your Flutter project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  extensionresoft: ^1.0.0
```

Then, run:

```bash
flutter pub get
````

to install the dependencies.

## Usage

Import the extensionresoft library in your Dart files:

```dart
import 'package:extensionresoft/extensionresoft.dart';
```

You can now use any of the extensions provided by the library in your Flutter project.

## Features

The extensionresoft library includes the following major extensions among others:

### Image Processing

#### Advanced Image Handling

- **Widget Versatility**: Implement both circular and rectangular image widgets with comprehensive placeholder support, error handling, caching
  mechanisms, and fallback options.
- **Resource Management**: Efficiently handle network and asset images for optimal display performance across your application.

### Security Features

#### PIN Authentication System

- **Widget Implementation**: Create robust and customizable PIN entry widgets designed for secure user authentication.
- **Security Enhancement**: Enhance user experience and security in your login screens.

### Network Operations

#### Connectivity Management

- **Real-time Monitoring**: Implement continuous network status checks for immediate connectivity awareness.
- **Graceful Handling**: Ensure seamless application performance during network state transitions.

### Data Management

#### Storage Solutions

- **SharedPreferencesService Implementation**: Utilize comprehensive persistent storage capabilities for multiple data types, including:
  - Boolean values
  - String data
  - Integer values
  - Double-precision numbers
- **Preference Management**: Implement efficient systems for handling application settings and user preferences.

### Extension Libraries

#### Context Extensions

- **Navigation Enhancement**: Streamline navigation operations with intuitive context extensions.
- **Code Optimization**: Implement cleaner, more maintainable code structures.

#### UI Extensions

- Icon Extensions
- List Extensions
- Numeric Extensions
- String Extensions

#### Logic Utilities

##### Conditional Operations

- **Logic Implementation**: Create concise conditional logic using optimized operators.

##### Value Management

- **Data Retrieval**: Implement robust value retrieval systems with configurable fallback options.

### Benefits

#### Development Efficiency

- **Code Reduction**: Minimize boilerplate code through reusable component implementation.
- **Task Simplification**: Streamline common development tasks with intuitive utilities.

#### Code Quality

- **Maintainability**: Improve code readability through well-structured extensions.
- **Documentation**: Implement clear, consistent naming conventions for enhanced understanding.

#### Productivity Enhancement

- **Focus Optimization**: Concentrate on core application logic development.
- **Time Management**: Reduce time spent on repetitive development tasks.

## Examples

Check out the Examples section below for code examples demonstrating how to use the extensions provided by the extensionresoft library.

```dart
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

void main() {

  // Secure PIN Entry
  PinEntry(
    pinLength: 4,
    onInputComplete: (pin) => print('Entered PIN: $pin'),
    inputFieldConfiguration: InputFieldConfiguration(
      obscureText: true,
      fieldFillColor: Colors.grey[200],
      focusedBorderColor: Colors.blue,
    ),
    keyboardConfiguration: KeyboardConfiguration(
      keyBackgroundColor: Colors.white,
      keyTextStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
  );

  // Internet Connection Management
  final connectionChecker = InternetConnectionChecker();

  // Listen to detailed connectivity changes
  connectionChecker.onInternetConnectivityChanged.listen((result) {
    print('Connection Status: ${result.hasInternetAccess}');
    print('Connection Type: ${result.connectionType}');
  });

  // Quick connection check
  final isConnected = await connectionChecker.isInternetConnected;

  // Circular Network/Asset Image
  AppCircleImage(
    'https://example.com/profile.jpg',
    radius: 40,
    assetFallback: 'assets/default_avatar.png',
    placeholder: CircularProgressIndicator(),
    errorWidget: Icon(Icons.error),
  );

  // Flexible Image Widget
  AppImage(
    'https://example.com/image.jpg',
    width: 200,
    height: 150,
    fit: BoxFit.cover,
    assetFallback: 'assets/placeholder.png',
  );

  // - as decoration image -
  Container(
    decoration: BoxDecoration(
      image: AppImage('https://example.com/background.jpg')
              .toDecorationImage(
        fit: BoxFit.cover,
        fallbackAsset: 'assets/default_bg.png',
      ),
    ),
  );
  
  // SpaceExtension Example
  final spacerX = 16.spaceX(); // Creates a SizedBox with a width of 16.
  final spacerY = 24.spaceY(); // Creates a SizedBox with a height of 24.
  final spacerXY = 32.spaceXY(); // Creates a SizedBox with both width and height of 32.
  final spacerXGetter = 20.spX; // Getter example: Creates a SizedBox with a width of 20.
  final spacerYGetter = 30.spY; // Getter example: Creates a SizedBox with a height of 30.
  final spacerXYGetter = 40.spXY; // Getter example: Creates a SizedBox with both width and height of 40.

  // CustomCardExtension Example
  final roundedCard = 16.radius(
    child: const Text('Hello World'),
    elevation: 4,
    color: Colors.blue,
    strokeColor: Colors.black,
    shadowColor: Colors.grey,
  ); // Creates a rounded card with specified properties.

  // PathExtension Example
  final result = 16.p((n) => n * 2); // Applies a function to the number 16 and returns the result.

  // TextExtension Example
  final textWidget = 'Hello'.edit(textStyle: const TextStyle(fontSize: 20), textAlign: TextAlign.center); // Creates a customized Text widget.

  // CustomImageExtension Example
  final imageWidget = 'assets/image.png'.img(
          width: 100, height: 100, fit: BoxFit.cover); // Creates an Image widget from an asset with specified properties.
  final circleImageContainer = 'assets/avatar.png'.circleImage(
          fit: BoxFit.cover, opacity: 0.8); // Creates a circular image container with specified properties.

  // Conditional Function Example
  final conditionResult = condition(true, 'True Value', 'False Value'); // Returns 'True Value' based on the condition.
  final conditionFunctionResult = conditionFunction(true, () => 'True Value', () => 'False Value'); // Invokes a function based on the condition.

  // Get Function Example
  final value = get('Existing Value', 'Default Value'); // Returns 'Existing Value' if not null, otherwise returns 'Default Value'.

  // SharedPreferencesService Example
  await SharedPreferencesService.init(); // Initializes SharedPreferencesService.
  await SharedPreferencesService.setBool('isDarkMode', true); // Sets a boolean value in SharedPreferences.
  final isDarkMode = SharedPreferencesService.getBool('isDarkMode'); // Retrieves the boolean value from SharedPreferences.
}

```

## Tests

Check out unit tests for the extensionresoft library to ensure the functionality of each extension.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:extensionresoft/extensionresoft.dart';

void main() {
  group('SpaceExtension', () {
    test('spaceX should return a SizedBox with specified width', () {
      final spacerX = 16.spaceX();
      expect(spacerX.width, equals(16.0));
    });

    test('spaceY should return a SizedBox with specified height', () {
      final spacerY = 24.spaceY();
      expect(spacerY.height, equals(24.0));
    });

    test('spaceXY should return a SizedBox with specified width and height', () {
      final spacerXY = 32.spaceXY();
      expect(spacerXY.width, equals(32.0));
      expect(spacerXY.height, equals(32.0));
    });

    test('spX getter should return a SizedBox with specified width', () {
      final spacerXGetter = 20.spX;
      expect(spacerXGetter.width, equals(20.0));
    });

    test('spY getter should return a SizedBox with specified height', () {
      final spacerYGetter = 30.spY;
      expect(spacerYGetter.height, equals(30.0));
    });

    test('spXY getter should return a SizedBox with specified width and height', () {
      final spacerXYGetter = 40.spXY;
      expect(spacerXYGetter.width, equals(40.0));
      expect(spacerXYGetter.height, equals(40.0));
    });
  });

  group('CustomCardExtension', () {
    test('radius should return a Card widget with specified properties', () {
      final Card roundedCard = 16.radius(
        child: const Text('Test'),
        elevation: 4,
        color: Colors.blue,
        strokeColor: Colors.black,
        shadowColor: Colors.grey,
      ) as Card;

      expect(roundedCard.elevation, equals(4));
      expect(roundedCard.color, equals(Colors.blue));
      expect(roundedCard.shadowColor, equals(Colors.grey));
    });
  });

  group('PathExtension', () {
    test('p function should apply function to number and return result', () {
      final result = 16.p((n) => n * 2);
      expect(result, equals(32.0));
    });
  });

  group('TextExtension', () {
    test('edit function should return a Text widget with specified properties', () {
      final textWidget = 'Hello'.edit(textStyle: const TextStyle(fontSize: 20), textAlign: TextAlign.center);
      expect(textWidget.data, equals('Hello'));
      expect(textWidget.style!.fontSize, equals(20));
      expect(textWidget.textAlign, equals(TextAlign.center));
    });
  });

  group('CustomImageExtension', () {
    test('img function should return an Image widget with specified properties', () {
      final imageWidget = 'assets/image.png'.img(width: 100, height: 100, fit: BoxFit.cover);
      expect(imageWidget.width, equals(100.0));
      expect(imageWidget.height, equals(100.0));
    });

    test('circleImage function should return a Container widget with circular image decoration', () {
      final circleImageContainer = 'assets/avatar.png'.circleImage(fit: BoxFit.cover, opacity: 0.8);
      //expect(circleImageContainer.decoration!.shape, equals(BoxShape.circle));
    });
  });

  group('Conditional Function', () {
    test('condition function should return correct value based on condition', () {
      final result = condition(true, 'True Value', 'False Value');
      expect(result, equals('True Value'));
    });

    test('conditionFunction should invoke correct function based on condition', () {
      final result = conditionFunction(true, () => 'True Value', () => 'False Value');
      expect(result, equals('True Value'));
    });
  });

  group('Get Function', () {
    test('get function should return correct value based on key and default value', () {
      final result = get('Existing Value', 'Default Value');
      expect(result, equals('Existing Value'));
    });
  });
}

```

## Screenshots

(None applicable in this current release)

[//]: # (Include any relevant screenshots or GIFs showcasing the extensions in action &#40;if applicable&#41;.)

## Contributing

Contributions to the extensionresoft library are welcome! If you have any ideas for new extensions or improvements to existing ones, please open an
issue or submit a pull request on GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
