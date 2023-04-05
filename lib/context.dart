
import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ColorScheme get theme {
    return Theme.of(this).colorScheme;
  }
}
