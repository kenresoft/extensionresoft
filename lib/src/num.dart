import 'package:flutter/material.dart';

/// Extension on num to create SizedBox widgets for spacing.
extension SpaceExtension on num {

  /// Creates a SizedBox with a width equal to the value of the number.
  ///
  /// The `spaceX()` function takes an optional `Widget` child.
  ///
  /// @param child The optional `Widget` child.
  /// @return A SizedBox with a width equal to the value of the number.
  ///
  /// Example:
  /// ```dart
  /// final spacer = 16.spaceX();
  /// ```
  SizedBox spaceX([Widget? child]) => SizedBox(width: toDouble(), child: child);

  /// Creates a SizedBox with a height equal to the value of the number.
  ///
  /// The `spaceY()` function takes an optional `Widget` child. <br /><br />
  ///
  /// @param child The optional `Widget` child. <br /><br />
  /// @return A SizedBox with a height equal to the value of the number. <br /><br />
  ///
  /// Example:
  /// ```dart
  /// final spacer = 16.spaceY();
  /// ```
  SizedBox spaceY([Widget? child]) => SizedBox(height: toDouble(), child: child);

  /// Creates a SizedBox with both width and height equal to the value of the number.
  ///
  /// The `spaceXY()` function takes an optional `Widget` child. <br /><br />
  ///
  /// @param child The optional `Widget` child. <br /><br />
  /// @return A SizedBox with both width and height equal to the value of the number. <br /><br />
  ///
  /// Example:
  /// ```dart
  /// final spacer = 16.spaceXY();
  /// ```
  SizedBox spaceXY([Widget? child]) => SizedBox(height: toDouble(), width: toDouble(), child: child);

  /// A Getter function that returns a SizedBox with a width equal to the value of the number.
  ///
  /// @return A SizedBox with a width equal to the value of the number.
  ///
  /// Example:
  /// ```dart
  /// final spacer = 16.spX;
  /// ```
  SizedBox get spX => SizedBox(width: toDouble());

  /// A Getter function that returns a SizedBox with a height equal to the value of the number.
  ///
  /// The `spY` getter function takes no parameters.
  /// @return A SizedBox with a height equal to the value of the number.
  ///
  /// Example:
  /// ```dart
  /// final spacer = 16.spY;
  /// ```
  SizedBox get spY => SizedBox(height: toDouble());

  /// A Getter function that returns a SizedBox with both width and height equal to the value of the number.
  ///
  /// The spXY getter function takes no parameters.
  /// @return A SizedBox with both width and height equal to the value of the number.
  ///
  /// Example:
  /// ```dart
  /// final spacer = 16.spXY;
  /// ```
  SizedBox get spXY => SizedBox(height: toDouble(), width: toDouble());
}

/// Extension on num to create a rounded card with a border.
extension CustomCardExtension on num {

  /// Creates a rounded card with a border.
  ///
  /// The `radius()` function creates a rounded card with a border. It takes a number as input and returns a `Widget`.
  ///
  /// @param child The required `Widget` child.
  /// @param elevation The elevation of the card.
  /// @param height The height of the card.
  /// @param width The width of the card.
  /// @param color The color of the card.
  /// @param strokeColor The color of the border.
  /// @param shadowColor The color of the shadow.
  /// @param margin The margin of the card.
  /// @param applyElevationTint Whether to apply the elevation tint to the card.
  /// @return A `Widget` that creates a rounded card with a border.
  ///
  /// Example:
  /// ```dart
  /// final card = 16.radius(
  ///   child: Text('Hello World'),
  ///   elevation: 4,
  ///   color: Colors.blue,
  ///   strokeColor: Colors.black,
  ///   shadowColor: Colors.grey,
  /// );
  /// ```
  Widget radius(
      {required Widget child,
      double elevation = 1,
      double? height,
      double? width,
      Color? color,
      Color? strokeColor = Colors.transparent,
      Color? shadowColor,
      EdgeInsets? margin,
      bool applyElevationTint = false}) {
    return SizedBox(
      height: height,
      width: width,
      child: Card(
        surfaceTintColor: !applyElevationTint ? Colors.white : null,
        shape: RoundedRectangleBorder(side: BorderSide(color: strokeColor!), borderRadius: BorderRadius.all(Radius.circular(toDouble()))),
        elevation: elevation,
        color: color,
        shadowColor: shadowColor ?? color,
        margin: margin,
        child: child,
      ),
    );
  }
}

/// Extension on num to apply a function to the number.
extension PathExtension on num {

  /// Applies a function to the number.
  ///
  /// The `p()` function takes a function as input and applies it to the number.
  ///
  /// @param key The function to apply to the number.
  /// @return The result of the function.
  ///
  /// Example:
  /// ```dart
  /// final result = 16.p((n) => n * 2);
  /// ```
  double p<T>(double Function(double n) key) {
    //if (this == null) return key;
    key(toDouble());
    return toDouble();
  }
}

