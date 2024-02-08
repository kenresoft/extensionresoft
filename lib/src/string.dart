import 'package:flutter/material.dart';

/// Extension on String to create Text widgets with customizable properties.
extension TextExtension on String {

  /// Creates a Text widget with customizable properties.
  ///
  /// The `edit()` function creates a Text widget with the specified textStyle, textAlign, and selectionColor.
  ///
  /// @param textStyle The TextStyle to apply to the text.
  /// @param textAlign The alignment of the text within its container.
  /// @param selectionColor The color to use for the text selection highlight.
  /// @return A Text widget with the specified properties.
  ///
  /// Example:
  /// ```dart
  /// final textWidget = 'Hello'.edit(textStyle: TextStyle(fontSize: 20), textAlign: TextAlign.center);
  /// ```
  Text edit({TextStyle? textStyle, TextAlign? textAlign, Color? selectionColor}) => Text(
        this,
        style: textStyle,
        textAlign: textAlign,
        selectionColor: selectionColor,
      );
}

/// Extension on String to create Image widgets with customizable properties.
extension CustomImageExtension on String {

  /// Creates an Image widget from an asset with customizable properties.
  ///
  /// The `img()` function creates an Image widget from the asset path with customizable scale, width, height, color, fit, alignment, and repeat properties.
  ///
  /// @param scale The scale factor for the image.
  /// @param width The width of the image.
  /// @param height The height of the image.
  /// @param color The color to blend with the image.
  /// @param fit How the image should be inscribed into the space.
  /// @param alignment How the image should be aligned within its container.
  /// @param repeat How the image should be repeated.
  /// @return An Image widget with the specified properties.
  ///
  /// Example:
  /// ```dart
  /// final imageWidget = 'assets/image.png'.img(width: 100, height: 100, fit: BoxFit.cover);
  /// ```
  Image img({
    double scale = 1.0,
    double? width,
    double? height,
    Color? color,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
  }) {
    return Image(
      image: ExactAssetImage(this, scale: scale),
      width: width,
      height: height,
      color: color,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
    );
  }

  /// Creates a circular image container with customizable properties.
  ///
  /// The `circleImage()` function creates a circular image container with customizable fit, alignment, repeat, scale, and opacity properties.
  ///
  /// @param fit How the image should be inscribed into the space.
  /// @param alignment How the image should be aligned within its container.
  /// @param repeat How the image should be repeated.
  /// @param scale The scale factor for the image.
  /// @param opacity The opacity of the image.
  /// @return A circular image container with the specified properties.
  ///
  /// Example:
  /// ```dart
  /// final circleImageContainer = 'assets/avatar.png'.circleImage(fit: BoxFit.cover, opacity: 0.8);
  /// ```
  Container circleImage({
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    double scale = 1.0,
    double opacity = 1.0,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: ExactAssetImage(this),
          fit: fit,
          alignment: alignment,
          repeat: repeat,
          scale: scale,
          opacity: opacity,
        ),
      ),
    );
  }
}
