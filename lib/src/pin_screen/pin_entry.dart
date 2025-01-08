import 'package:flutter/material.dart';

import 'pin_configurations.dart';
import 'pin_input_field.dart';
import 'pin_keyboard.dart';

/// A widget for handling PIN entry, integrating input fields and a keyboard.
///
/// The `PinEntry` widget provides a comprehensive solution for PIN entry,
/// combining input fields, a keyboard, and additional widgets for customization.
///
/// ### Example
/// ```dart
/// PinEntry(
///   pinLength: 6,
///   onInputComplete: (pin) => print('Entered PIN: $pin'),
///   middleWidget: Text('Enter your PIN'),
///   keyboardConfiguration: KeyboardConfiguration(),
///   inputFieldConfiguration: InputFieldConfiguration(),
/// );
/// ```
class PinEntry extends StatefulWidget {
  /// Length of the PIN to be entered.
  final int pinLength;

  /// Callback triggered when the PIN entry is complete.
  final Function(String pin)? onInputComplete;

  /// Widget displayed between the input fields and keyboard.
  final Widget? middleWidget;

  /// Whether to center the middle widget.
  final bool centerMiddleWidget;

  /// Configuration for the PIN keyboard.
  final KeyboardConfiguration keyboardConfiguration;

  /// Configuration for the input fields.
  final InputFieldConfiguration inputFieldConfiguration;

  const PinEntry({
    super.key,
    this.pinLength = 4,
    this.onInputComplete,
    // this.topWidget,
    this.middleWidget,
    // this.bottomWidget,
    this.centerMiddleWidget = false,
    this.keyboardConfiguration = const KeyboardConfiguration(),
    this.inputFieldConfiguration =
        const InputFieldConfiguration(), // Default input field configuration
  });

  @override
  State<PinEntry> createState() => _PinEntryState();
}

class _PinEntryState extends State<PinEntry> {
  late List<String> _pin;
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  bool _isInputComplete = false;

  @override
  void initState() {
    super.initState();
    _pin = List.filled(widget.pinLength, '');
    _controllers =
        List.generate(widget.pinLength, (index) => TextEditingController());
    _focusNodes = List.generate(widget.pinLength, (index) => FocusNode());
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PinEntry oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Handle obscure text changes
    if (widget.inputFieldConfiguration.obscureText !=
        oldWidget.inputFieldConfiguration.obscureText) {
      setState(() {
        for (int i = 0; i < _controllers.length; i++) {
          String currentText = _pin[i];
          if (widget.inputFieldConfiguration.obscureText) {
            _controllers[i].text = currentText.isNotEmpty
                ? widget.inputFieldConfiguration.obscuringCharacter
                : '';
          } else {
            _controllers[i].text = currentText;
          }
        }
      });
    }

    // Handle pin length changes
    if (widget.pinLength != oldWidget.pinLength) {
      _pin = List.filled(widget.pinLength, '');
      _controllers =
          List.generate(widget.pinLength, (index) => TextEditingController());
      _focusNodes = List.generate(widget.pinLength, (index) => FocusNode());
    }

    // Check if other widget properties changed that might require a rebuild
    if (widget.inputFieldConfiguration.fieldFillColor !=
            oldWidget.inputFieldConfiguration.fieldFillColor ||
        widget.inputFieldConfiguration.borderColor !=
            oldWidget.inputFieldConfiguration.borderColor ||
        widget.inputFieldConfiguration.focusedBorderColor !=
            oldWidget.inputFieldConfiguration.focusedBorderColor ||
        // widget.topWidget != oldWidget.topWidget ||
        widget.middleWidget != oldWidget.middleWidget ||
        // widget.bottomWidget != oldWidget.bottomWidget ||
        widget.centerMiddleWidget != oldWidget.centerMiddleWidget) {
      setState(() {});
    }
  }

  void _handleKeyInput(String key) {
    if (key == 'delete') {
      for (int i = _controllers.length - 1; i >= 0; i--) {
        if (_controllers[i].text.isNotEmpty) {
          _controllers[i].clear();
          _pin[i] = '';
          FocusScope.of(context).requestFocus(_focusNodes[i]);
          break;
        }
      }
    } else {
      int emptyIndex =
          _controllers.indexWhere((controller) => controller.text.isEmpty);
      if (emptyIndex != -1) {
        _controllers[emptyIndex].text =
            widget.inputFieldConfiguration.obscureText
                ? widget.inputFieldConfiguration.obscuringCharacter
                : key;
        _pin[emptyIndex] = key;
        if (emptyIndex + 1 < _controllers.length) {
          FocusScope.of(context).requestFocus(_focusNodes[emptyIndex + 1]);
        }
      }
    }

    setState(() {
      _isInputComplete =
          _controllers.every((controller) => controller.text.isNotEmpty);
      if (_isInputComplete && widget.onInputComplete != null) {
        widget.onInputComplete!(_pin.join());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    double verticalPadding = screenHeight * 0.002;
    double horizontalPadding = screenWidth * 0.05;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PinInputField(
            controllers: _controllers,
            focusNodes: _focusNodes,
            fieldCount: widget.pinLength,
            fieldFillColor: widget.inputFieldConfiguration.fieldFillColor,
            borderColor: widget.inputFieldConfiguration.borderColor,
            focusedBorderColor:
                widget.inputFieldConfiguration.focusedBorderColor,
            obscureText: widget.inputFieldConfiguration.obscureText,
            obscuringCharacter:
                widget.inputFieldConfiguration.obscuringCharacter,
            inputHeight: widget.inputFieldConfiguration.inputHeight,
            textStyle: widget.inputFieldConfiguration.textStyle,
          ),
          SizedBox(height: verticalPadding),
          if (widget.middleWidget != null)
            widget.centerMiddleWidget
                ? Padding(
                    padding: EdgeInsets.only(top: verticalPadding),
                    child: widget.middleWidget!,
                  )
                : widget.middleWidget!,
          SizedBox(height: verticalPadding),
          PinKeyboard(
            onKeyPressed: (key) {
              _handleKeyInput(key);
              widget.keyboardConfiguration.onKeyPressed?.call(key);
            },
            keys: widget.keyboardConfiguration.keys,
            keyBackgroundColor: widget.keyboardConfiguration.keyBackgroundColor,
            keyTextColor: widget.keyboardConfiguration.keyTextColor,
            keyTextStyle: widget.keyboardConfiguration.keyTextStyle,
            buttonHeight: widget.keyboardConfiguration.buttonHeight,
            flexibleButton: widget.keyboardConfiguration.flexibleButton,
          ),
        ],
      ),
    );
  }
}
