import 'package:flutter/material.dart';

extension SpaceExtention on num {
  /// A SizedBox that has a width of the `toDouble()` function's result.
  ///
  /// The `spaceX()` function takes an optional `Widget` child.
  ///
  /// @param child The optional `Widget` child.
  ///
  /// @return A SizedBox with a width of the `toDouble()` function's result.
  SizedBox spaceX([Widget? child]) => SizedBox(width: toDouble(), child: child);

  /// A SizedBox that has a height of the `toDouble()` function's result.
  ///
  /// The `spaceY()` function takes an optional `Widget` child.
  ///
  /// @param child The optional `Widget` child.
  /// @return A SizedBox with a height of the `toDouble()` function's result.
  SizedBox spaceY([Widget? child]) => SizedBox(height: toDouble(), child: child);

  /// A SizedBox that has both a width and height of the `toDouble()` function's result.
  ///
  /// The `spaceXY()` function takes an optional `Widget` child.
  ///
  /// @param child The optional `Widget` child.
  /// @return A SizedBox with both a width and height of the `toDouble()` function's result.
  SizedBox spaceXY([Widget? child]) => SizedBox(height: toDouble(), width: toDouble(), child: child);


  /// A Getter function that returns a SizedBox with a width of the `toDouble()` function's result.
  ///
  /// The `spX` getter function takes no parameters.
  ///
  /// @return A SizedBox with a width of the `toDouble()` function's result.
  SizedBox get spX => SizedBox(width: toDouble());

  /// A Getter function that returns a SizedBox with a height of the `toDouble()` function's result.
  ///
  /// The `spY` getter function takes no parameters.
  ///
  /// @return A SizedBox with a height of the `toDouble()` function's result.
  SizedBox get spY => SizedBox(height: toDouble());

  /// A Getter function that returns a SizedBox with both a width and height of the toDouble() function's result.
  ///
  /// The spXY getter function takes no parameters.
  ///
  /// @return A SizedBox with both a width and height of the toDouble() function's result.
  SizedBox get spXY => SizedBox(height: toDouble(), width: toDouble());
}

extension CustomCard on num {
  /// A Widget that creates a rounded card with a border.
  ///
  /// The `radius()` function takes a number as input and returns a `Widget`.
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

extension PathExtension on num {
  /// A function that takes a number as input and applies a function to it.
  ///
  /// The `p()` function takes a number as input and applies a function to it.
  ///
  /// @param key The function to apply to the number.
  /// @return The result of the function.
  double p<T>(double Function(double n) key) {
    //if (this == null) return key;
    key(toDouble());
    return toDouble();
  }
}

