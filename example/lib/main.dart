import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

void main() {
  // SpaceExtension Example
  final spacerX = 16.spaceX(); // Creates a SizedBox with a width of 16.
  final spacerY = 24.spaceY(); // Creates a SizedBox with a height of 24.
  final spacerXY =
      32.spaceXY(); // Creates a SizedBox with both width and height of 32.
  final spacerXGetter =
      20.spX; // Getter example: Creates a SizedBox with a width of 20.
  final spacerYGetter =
      30.spY; // Getter example: Creates a SizedBox with a height of 30.
  final spacerXYGetter = 40
      .spXY; // Getter example: Creates a SizedBox with both width and height of 40.

  // CustomCardExtension Example
  final roundedCard = 16.radius(
    child: const Text('Hello World'),
    elevation: 4,
    color: Colors.blue,
    strokeColor: Colors.black,
    shadowColor: Colors.grey,
  ); // Creates a rounded card with specified properties.

  // PathExtension Example
  final result = 16.p((n) =>
      n * 2); // Applies a function to the number 16 and returns the result.

  // TextExtension Example
  final textWidget = 'Hello'.edit(
      textStyle: const TextStyle(fontSize: 20),
      textAlign: TextAlign.center); // Creates a customized Text widget.

  // CustomImageExtension Example
  final imageWidget = 'assets/image.png'.img(
      width: 100,
      height: 100,
      fit: BoxFit
          .cover); // Creates an Image widget from an asset with specified properties.
  final circleImageContainer = 'assets/avatar.png'.circleImage(
      fit: BoxFit.cover,
      opacity:
          0.8); // Creates a circular image container with specified properties.

  // Conditional Function Example
  final conditionResult = condition(true, 'True Value',
      'False Value'); // Returns 'True Value' based on the condition.
  final conditionFunctionResult = conditionFunction(true, () => 'True Value',
      () => 'False Value'); // Invokes a function based on the condition.

  // Get Function Example
  final value = get('Existing Value',
      'Default Value'); // Returns 'Existing Value' if not null, otherwise returns 'Default Value'.
}
