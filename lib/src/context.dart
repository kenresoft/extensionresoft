
import 'package:flutter/material.dart';

/// Extension on BuildContext to easily access the ColorScheme of the current theme.
extension ThemeExtension on BuildContext {

  /// Returns the ColorScheme of the current theme. <br /><br />
  ///
  /// Example:
  /// ```dart
  /// final colorScheme = context.theme;
  /// final primaryColor = colorScheme.primary;
  /// ```
  ColorScheme get theme {
    return Theme.of(this).colorScheme;
  }
}
