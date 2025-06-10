// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

/// Password visibility configuration for customizing password fields
class PasswordVisibilityConfig {
  /// Path to the user's custom asset for visibility on (password hidden)
  final String? customVisibilityOnIconPath;

  /// Path to the user's custom asset for visibility off (password shown)
  final String? customVisibilityOffIconPath;

  /// Widget to use for visibility on (overrides any path)
  final Widget? customVisibilityOnIcon;

  /// Widget to use for visibility off (overrides any path)
  final Widget? customVisibilityOffIcon;

  /// Color to use for the icons
  final Color? iconColor;

  /// Size of the icons
  final double iconSize;

  /// Tap area padding
  final EdgeInsetsGeometry iconPadding;

  /// Tooltip text for accessibility
  final String visibilityOnTooltip;
  final String visibilityOffTooltip;

  const PasswordVisibilityConfig({
    this.customVisibilityOnIconPath,
    this.customVisibilityOffIconPath,
    this.customVisibilityOnIcon,
    this.customVisibilityOffIcon,
    this.iconColor,
    this.iconSize = 24.0,
    this.iconPadding = const EdgeInsets.only(left: 8, right: 8),
    this.visibilityOnTooltip = 'Show password',
    this.visibilityOffTooltip = 'Hide password',
  });

  /// Default configuration
  static const PasswordVisibilityConfig defaultConfig = PasswordVisibilityConfig();
}

/// Animation configuration for text field transitions
class TextFieldAnimationConfig {
  final Duration focusTransitionDuration;
  final Curve focusCurve;
  final Duration errorTransitionDuration;
  final Curve errorCurve;
  final Duration validationFeedbackDuration;

  const TextFieldAnimationConfig({
    this.focusTransitionDuration = const Duration(milliseconds: 200),
    this.focusCurve = Curves.easeInOut,
    this.errorTransitionDuration = const Duration(milliseconds: 300),
    this.errorCurve = Curves.elasticOut,
    this.validationFeedbackDuration = const Duration(milliseconds: 150),
  });

  /// Default animation configuration
  static const TextFieldAnimationConfig defaultConfig = TextFieldAnimationConfig();
}
