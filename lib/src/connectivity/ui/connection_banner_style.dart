// lib/src/connection_banner_style.dart
import 'package:flutter/material.dart';

class ConnectionBannerStyle {
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final IconData icon;
  final double height;
  final double borderRadius;
  final Duration animationDuration;
  final List<BoxShadow>? boxShadow;
  final TextStyle textStyle;

  const ConnectionBannerStyle({
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.icon = Icons.wifi_off,
    this.height = 48.0,
    this.borderRadius = 8.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.boxShadow,
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16),
  });

  // Predefined styles for convenience
  factory ConnectionBannerStyle.online() {
    return const ConnectionBannerStyle(
      backgroundColor: Colors.green,
      icon: Icons.wifi,
    );
  }

  factory ConnectionBannerStyle.offline() {
    return const ConnectionBannerStyle(
      backgroundColor: Colors.red,
      icon: Icons.wifi_off,
    );
  }

  factory ConnectionBannerStyle.custom({
    Color? backgroundColor,
    Color? textColor,
    Color? iconColor,
    IconData? icon,
    double? height,
    double? borderRadius,
    Duration? animationDuration,
    List<BoxShadow>? boxShadow,
    TextStyle? textStyle,
  }) {
    return ConnectionBannerStyle(
      backgroundColor: backgroundColor ?? Colors.red,
      textColor: textColor ?? Colors.white,
      iconColor: iconColor ?? Colors.white,
      icon: icon ?? Icons.wifi_off,
      height: height ?? 48.0,
      borderRadius: borderRadius ?? 8.0,
      animationDuration: animationDuration ?? const Duration(milliseconds: 300),
      boxShadow: boxShadow,
      textStyle:
          textStyle ?? const TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}
