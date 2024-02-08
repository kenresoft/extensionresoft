import 'package:flutter/material.dart';

/// Extension on IconData to create an Icon widget with customizable size and color.
extension IconExtension on IconData {
  /// Creates an Icon widget using the current IconData with optional size and color.
  ///
  /// This extension simplifies the creation of Icon widgets with the given IconData, size, and color.
  ///
  /// Parameters:
  ///   - size: The size of the icon. If not provided, it uses the default size defined in the Icon widget.
  ///   - color: The color of the icon. If not provided, it uses the default color defined in the Icon widget.
  ///
  /// Example:
  /// ```dart
  /// final editIcon = Icons.contact.edit(size: 24, color: Colors.blue);
  /// ```
  Icon edit({double? size, Color? color}) {
    return Icon(
      this,
      size: size,
      color: color,
    );
  }
}
