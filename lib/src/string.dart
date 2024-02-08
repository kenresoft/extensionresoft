import 'package:flutter/material.dart';

/// Extension on String to create Text widgets with customizable properties.
extension TextExtension on String {

  /// Creates a Text widget with customizable properties.
  ///
  /// The `edit()` function creates a Text widget with the specified textStyle, textAlign, and selectionColor. <br /><br />
  ///
  /// @param textStyle The TextStyle to apply to the text. <br /><br />
  /// @param textAlign The alignment of the text within its container. <br /><br />
  /// @param selectionColor The color to use for the text selection highlight. <br /><br />
  /// @return A Text widget with the specified properties. <br /><br />
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
  /// The `img()` function creates an Image widget from the asset path with customizable scale, width, height, color, fit, alignment, and repeat properties. <br /><br />
  ///
  /// @param scale The scale factor for the image. <br /><br />
  /// @param width The width of the image. <br /><br />
  /// @param height The height of the image. <br /><br />
  /// @param color The color to blend with the image. <br /><br />
  /// @param fit How the image should be inscribed into the space. <br /><br />
  /// @param alignment How the image should be aligned within its container. <br /><br />
  /// @param repeat How the image should be repeated. <br /><br />
  /// @return An Image widget with the specified properties. <br /><br />
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
  /// The `circleImage()` function creates a circular image container with customizable fit, alignment, repeat, scale, and opacity properties. <br /><br />
  ///
  /// @param fit How the image should be inscribed into the space. <br /><br />
  /// @param alignment How the image should be aligned within its container. <br /><br />
  /// @param repeat How the image should be repeated. <br /><br />
  /// @param scale The scale factor for the image. <br /><br />
  /// @param opacity The opacity of the image. <br /><br />
  /// @return A circular image container with the specified properties. <br /><br />
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
