import 'package:flutter/material.dart';

/// Configuration options for input fields used in the PIN entry widget.
///
/// The `InputFieldConfiguration` allows customization of various visual
/// aspects, including colors, text styles, and input behaviors.
class InputFieldConfiguration {
  /// Background color of the input field.
  final Color fieldFillColor;

  /// Border color of the input field.
  final Color borderColor;

  /// Border color when the field is focused.
  final Color focusedBorderColor;

  /// Text style for the input characters.
  final TextStyle textStyle;

  /// Whether to obscure the text input for security.
  final bool obscureText;

  /// Character used to obscure text.
  final String obscuringCharacter;

  /// Height of the input field.
  final double inputHeight;

  const InputFieldConfiguration({
    this.fieldFillColor = const Color(0xFF282828),
    this.borderColor = Colors.grey,
    this.focusedBorderColor = const Color(0xFF2FA2B9),
    this.textStyle = const TextStyle(
      color: Color(0xFFEFEFEF),
      fontSize: 21,
      fontWeight: FontWeight.w600,
    ),
    this.obscureText = true,
    this.obscuringCharacter = '⁕',
    this.inputHeight = 56.0, // Default height for input fields
  });
}

/// Configuration options for the PIN keyboard.
///
/// The `KeyboardConfiguration` allows setting up the visual and functional
/// aspects of the keyboard, such as keys, styles, and layout behavior.
class KeyboardConfiguration {
  /// Callback triggered when a key is pressed.
  final Function(String)? onKeyPressed;

  /// List of keys to display on the keyboard.
  final List<String> keys;

  /// Background color for the keys.
  final Color keyBackgroundColor;

  /// Text color for the keys.
  final Color keyTextColor;

  /// Custom text style for key labels.
  final TextStyle? keyTextStyle;

  /// Height of the individual keys.
  final double buttonHeight;

  /// Whether the buttons should adjust their size dynamically.
  final bool flexibleButton;

  const KeyboardConfiguration({
    this.onKeyPressed,
    // Default keypad values if not provided by the user
    this.keys = const ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', 'delete'],
    this.keyBackgroundColor = const Color(0xff222222),
    this.keyTextColor = const Color(0xffC5C5C5),
    this.keyTextStyle,
    this.buttonHeight = 56.0,
    this.flexibleButton = false,
  });
}
