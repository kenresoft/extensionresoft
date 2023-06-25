import 'package:flutter/material.dart';

extension IconExtension on IconData {
  Icon edit({double? size, Color? color}) {
    return Icon(
      this,
      size: size,
      color: color,
    );
  }
}
