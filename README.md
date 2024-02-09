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

A collection of useful Dart/Flutter Extension functions and Helper functions for faster development.
This was developed to aide developers write minimized but powerful codes.
This makes for codes re-usability and easy coding reading.
It's aimed at enhancing productivity and improving code readability.

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
  extensionresoft: ^0.0.3
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

- **_SpaceExtension_**: Provides methods for creating SizedBox widgets with customizable dimensions.
- **_CustomCardExtension_**: Offers methods for creating custom Card widgets with rounded corners and other properties.
- **_PathExtension_**: Provides a method for applying functions to numbers.
- **_TextExtension_**: Offers a method for creating Text widgets with customizable properties from strings.
- **_CustomImageExtension_**: Provides methods for creating Image widgets and circular image containers with customizable properties.
- **_Conditional Function_**: Provides functions for conditionally returning values.
- **_Get Function_**: Provides a function for getting values with optional default values.

## Examples

Check out the Examples section below for code examples demonstrating how to use the extensions provided by the extensionresoft library.

```dart
import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

void main() {
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
  final imageWidget = 'assets/image.png'.img(width: 100, height: 100, fit: BoxFit.cover); // Creates an Image widget from an asset with specified properties.
  final circleImageContainer = 'assets/avatar.png'.circleImage(fit: BoxFit.cover, opacity: 0.8); // Creates a circular image container with specified properties.

  // Conditional Function Example
  final conditionResult = condition(true, 'True Value', 'False Value'); // Returns 'True Value' based on the condition.
  final conditionFunctionResult = conditionFunction(true, () => 'True Value', () => 'False Value'); // Invokes a function based on the condition.

  // Get Function Example
  final value = get('Existing Value', 'Default Value'); // Returns 'Existing Value' if not null, otherwise returns 'Default Value'.
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
Contributions to the extensionresoft library are welcome! If you have any ideas for new extensions or improvements to existing ones, please open an issue or submit a pull request on GitHub.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
