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
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

## Installation
To use the extensionresoft library in your Flutter project, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  extensionresoft: ^0.0.1
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
The extensionresoft library includes the following extensions:

- **SpaceExtension**: Provides methods for creating SizedBox widgets with customizable dimensions.
- **CustomCardExtension**: Offers methods for creating custom Card widgets with rounded corners and other properties.
- **PathExtension**: Provides a method for applying functions to numbers.
- **TextExtension**: Offers a method for creating Text widgets with customizable properties from strings.
- **CustomImageExtension**: Provides methods for creating Image widgets and circular image containers with customizable properties.
- **Conditional Function**: Provides functions for conditionally returning values.
- **Get Function**: Provides a function for getting values with optional default values.

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

More examples can be found in the example [main.dart](example/lib/main.dart)

## Screenshots
(None applicable in this current release)

[//]: # (Include any relevant screenshots or GIFs showcasing the extensions in action &#40;if applicable&#41;.)

## Contributing
Contributions to the extensionresoft library are welcome! If you have any ideas for new extensions or improvements to existing ones, please open an issue or submit a pull request on GitHub.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
