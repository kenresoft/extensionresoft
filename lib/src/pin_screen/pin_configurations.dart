import 'package:flutter/material.dart';

class InputFieldConfiguration {
  final Color fieldFillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final TextStyle textStyle;
  final bool obscureText;
  final String obscuringCharacter;
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

class KeyboardConfiguration {
  final Function(String)? onKeyPressed;
  final List<String> keys;
  final Color keyBackgroundColor;
  final Color keyTextColor;
  final TextStyle? keyTextStyle;
  final double buttonHeight;
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