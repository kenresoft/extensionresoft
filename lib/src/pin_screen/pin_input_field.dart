import 'package:flutter/material.dart';

class PinInputField extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final int fieldCount;
  final Color fieldFillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final TextStyle textStyle;
  final bool obscureText;
  final String obscuringCharacter;
  final double inputHeight; // Added inputHeight

  const PinInputField({
    super.key,
    required this.controllers,
    required this.focusNodes,
    this.fieldCount = 4,
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
    required this.inputHeight, // Added inputHeight as a required field
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the width of each input field based on screen width
        double inputWidth = _getResponsiveInputWidth(constraints.maxWidth);

        // Use calculated width and definite inputHeight for each input field
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(fieldCount, (index) {
            return Flexible(
              child: _buildPinInputField(context, index, inputWidth, inputHeight),
            );
          }),
        );
      },
    );
  }

  // Dynamically calculate the width of each input field
  double _getResponsiveInputWidth(double maxWidth) {
    if (maxWidth <= 400) {
      return maxWidth / (fieldCount + 1.5); // Narrow screens (e.g., phones)
    } else if (maxWidth <= 800) {
      return maxWidth / (fieldCount + 2); // Tablets or medium screens
    } else {
      return maxWidth / (fieldCount + 3); // Large screens or landscape mode
    }
  }

  // Helper method to build each input field widget
  Widget _buildPinInputField(BuildContext context, int index, double inputWidth, double inputHeight) {
    return Container(
      width: inputWidth,
      height: inputHeight, // Use definite inputHeight
      // margin: EdgeInsets.only(right: index < fieldCount - 1 ? 10.0 : 0.0),
      child: TextFormField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        maxLength: 1,
        maxLines: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.none,
        style: textStyle.copyWith(
          fontSize: inputHeight * 0.5,
          height: 0,
        ),
        // Responsive font size
        obscureText: obscureText,
        obscuringCharacter: obscuringCharacter,
        decoration: InputDecoration(
          counter: const Offstage(),
          filled: true,
          fillColor: fieldFillColor,
          enabledBorder: _inputBorderStyle(borderColor),
          focusedBorder: _inputBorderStyle(focusedBorderColor),
          contentPadding: EdgeInsets.symmetric(vertical: inputHeight * 0.2), // Adjust padding based on height
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            controllers[index].text = value[0];
            if (index + 1 < fieldCount) {
              FocusScope.of(context).requestFocus(focusNodes[index + 1]);
            }
          }
        },
      ),
    );
  }

  // Custom border style for input fields
  OutlineInputBorder _inputBorderStyle(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: 2),
    );
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
}
