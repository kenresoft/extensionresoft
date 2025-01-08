import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget representing a numeric PIN keyboard with configurable keys, styles, and functionality.
///
/// The `PinKeyboard` widget provides a customizable PIN input keyboard, suitable for numeric and symbol keys.
/// It supports features like dynamic button sizing and flexible layouts.
///
/// ### Example
/// ```dart
/// PinKeyboard(
///   onKeyPressed: (key) => print(key),
///   keys: ['1', '2', '3', '4', '5', '6', '7', '8', '9', '*', '0', 'delete'],
///   keyBackgroundColor: Colors.blue,
///   keyTextColor: Colors.white,
///   buttonHeight: 60.0,
///   flexibleButton: true,
/// );
/// ```
class PinKeyboard extends StatefulWidget {
  /// Callback triggered when a key is pressed.
  final Function(String key) onKeyPressed;

  /// List of keys to display on the keyboard.
  final List<String> keys;

  /// Background color for the keys.
  final Color keyBackgroundColor;

  /// Text color for the keys.
  final Color keyTextColor;

  /// Custom text style for the key labels. If null, default styles are applied.
  final TextStyle? keyTextStyle;

  /// Height of the individual keys.
  final double buttonHeight;

  /// Whether the buttons should adjust their size dynamically.
  final bool flexibleButton;

  const PinKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.keys,
    required this.keyBackgroundColor,
    required this.keyTextColor,
    this.keyTextStyle,
    required this.buttonHeight,
    required this.flexibleButton,
  });

  @override
  State<PinKeyboard> createState() => _PinKeyboardState();
}

class _PinKeyboardState extends State<PinKeyboard> {
  late List<String> _keys;

  @override
  void initState() {
    super.initState();
    _keys = widget.keys;
  }

  @override
  void didUpdateWidget(covariant PinKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.keys, oldWidget.keys)) {
      setState(() {
        _keys = widget.keys;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Button width calculated based on the available space divided by 3 (3 buttons per row)
        double buttonWidth = (constraints.maxWidth / 3) - 10;

        // Use the provided buttonHeight from the widget
        double buttonHeight = widget.buttonHeight;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildRow([0, 1, 2], buttonWidth, buttonHeight),
              _buildRow([3, 4, 5], buttonWidth, buttonHeight),
              _buildRow([6, 7, 8], buttonWidth, buttonHeight),
              _buildRow([9, 10, 11], buttonWidth, buttonHeight), // '*', '0', 'delete'
            ],
          ),
        );
      },
    );
  }

  // Method to build each row of keys (three keys per row)
  Widget _buildRow(List<int> indexes, double buttonWidth, double buttonHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: indexes.map((index) {
        String keyLabel = _keys[index];
        IconData? keyIcon;

        // Icon for the delete button
        if (keyLabel == 'delete') {
          keyIcon = CupertinoIcons.arrow_turn_up_left;
        }

        return Flexible(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey)),
            // shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: Colors.grey)),
            color: Colors.transparent, // Make the card transparent to show custom decoration
            elevation: 0, // Remove shadow
            child: _buildKeyboardButton(
              index,
              keyLabel,
              keyIcon,
              buttonWidth,
              buttonHeight,
            ),
          ),
        );
      }).toList(),
    );
  }

  // Method to build individual keyboard buttons
  Widget _buildKeyboardButton(
    int index,
    String text,
    IconData? iconData,
    double buttonWidth,
    double buttonHeight,
  ) {
    return Container(
      width: buttonWidth,
      height: buttonHeight,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: widget.keyBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => widget.onKeyPressed(text), // Trigger the onKeyPressed callback
        child: Center(
          child: iconData == null
              ? Text(
                  text,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: widget.keyTextStyle ??
                      TextStyle(
                        color: widget.keyTextColor,
                        fontSize: _getFontSize(buttonHeight), // Dynamic font size based on height
                        height: _getTextHeight(buttonHeight), // Dynamic line height based on height
                        fontWeight: FontWeight.w500,
                      ),
                )
              : Icon(
                  iconData,
                  size: _getIconSize(buttonHeight), // Dynamic icon size based on height
                  color: widget.keyTextColor,
                ), // Icon for delete button
        ),
      ),
    );
  }

  // Calculate dynamic font size based on button height
  double _getFontSize(double buttonHeight) {
    if (buttonHeight > 100) {
      return 36; // Large font size for large buttons
    } else if (buttonHeight > 70) {
      return 32; // Medium font size
    } else {
      return 28; // Small font size for smaller buttons
    }
  }

  // Calculate dynamic line height based on button height
  double _getTextHeight(double buttonHeight) {
    if (buttonHeight > 100) {
      return 1.0; // Suitable line height for very large buttons
    } else if (buttonHeight > 70) {
      return 1.1; // Slightly increased line height for medium buttons
    } else {
      return 1.2; // Increased line height for smaller buttons
    }
  }

  // Calculate dynamic icon size based on button height
  double _getIconSize(double buttonHeight) {
    if (buttonHeight > 100) {
      return 40;
    } else if (buttonHeight > 70) {
      return 35;
    } else {
      return 30;
    }
  }
}
