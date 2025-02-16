// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

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
