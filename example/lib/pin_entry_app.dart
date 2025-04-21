import 'package:extensionresoft/extensionresoft.dart';
import 'package:flutter/material.dart';

void main() => runApp(const PinEntryApp());

class PinEntryApp extends StatelessWidget {
  const PinEntryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Enter PIN")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Please enter your PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              PinEntry(
                pinLength: 5,
                onInputComplete: logger.d,
                inputFieldConfiguration: const InputFieldConfiguration(
                  obscureText: true,
                  fieldFillColor: Colors.grey,
                  focusedBorderColor: Colors.teal,
                  borderColor: Colors.black26,
                ),
                middleWidget: const Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      "Verification",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                centerMiddleWidget: true,
                keyboardConfiguration: const KeyboardConfiguration(
                  keyBackgroundColor: Colors.white,
                  keyTextStyle: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  flexibleButton: true,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
