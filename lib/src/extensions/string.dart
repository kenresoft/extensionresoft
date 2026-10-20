// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';


/// Extension on String to create Text widgets with customizable properties.
extension TextExtension on String {
  /// Capitalizes the first letter of the string.
  ///
  /// Returns the string with the first letter capitalized. If the string is empty,
  /// it returns the empty string.
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

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
  Text edit({TextStyle? textStyle, TextAlign? textAlign, Color? selectionColor}) =>
      Text(this, style: textStyle, textAlign: textAlign, selectionColor: selectionColor);
}
