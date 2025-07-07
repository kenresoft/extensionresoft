// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'app_circle_image.dart';
import 'app_image.dart';

/// A widget that displays either a standard or circular image background
/// with overlayed content.
class ImageBackground extends StatelessWidget {
  /// The image to display in the background
  final dynamic imageSource;

  /// The widget to display over the background image
  final Widget child;

  /// The width of the background
  final double? width;

  /// The height of the background
  final double? height;

  /// How the image should be inscribed into the space
  final BoxFit fit;

  /// How to align the child within the parent
  final AlignmentGeometry childAlignment;

  /// Optional color to overlay on the image for better content visibility
  final Color? imageOverlayColor;

  /// Widget displayed while the target [imageSource] is loading
  final Widget? placeholder;

  /// Widget displayed if the target [imageSource] fails to load
  final Widget? errorWidget;

  /// Fallback image to display if the target [imageSource] fails to load
  final String? fallbackImagePath;

  /// The border radius of the background
  final BorderRadius? borderRadius;

  /// Background color displayed behind the image
  final Color? backgroundColor;

  /// When non-null, displays the image as a circle with given radius
  final double? circleRadius;

  /// Default width for the background when not specified
  static const double defaultWidth = 300.0;

  /// Default height for the background when not specified
  static const double defaultHeight = 200.0;

  /// Creates an image background with overlayed content
  const ImageBackground({
    super.key,
    required this.imageSource,
    required this.child,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.childAlignment = Alignment.center,
    this.imageOverlayColor,
    this.placeholder,
    this.errorWidget,
    this.fallbackImagePath,
    this.borderRadius,
    this.backgroundColor,
  }) : circleRadius = null;

  /// Creates a circular image background with overlayed content
  /// TODO: We're still testing functionality for edge cases.
  const ImageBackground.circle({
    super.key,
    required this.imageSource,
    required this.child,
    required double radius,
    this.fit = BoxFit.cover,
    this.childAlignment = Alignment.center,
    this.imageOverlayColor,
    this.placeholder,
    this.errorWidget,
    this.fallbackImagePath,
    this.backgroundColor = const Color(0xFFE0E0E0),
  }) : circleRadius = radius,
       width = radius * 2,
       height = radius * 2,
       borderRadius = null;

  @override
  Widget build(BuildContext context) {
    final effectiveWidth =
        width ?? (circleRadius != null ? circleRadius! * 2 : defaultWidth);
    final effectiveHeight =
        height ?? (circleRadius != null ? circleRadius! * 2 : defaultHeight);

    Widget content = SizedBox(
      width: effectiveWidth,
      height: effectiveHeight,
      child: Stack(
        alignment: childAlignment,
        fit: StackFit.expand,
        children: [
          // Background image (standard or circular)
          _buildBackgroundImage(),

          // Image overlay
          if (imageOverlayColor != null)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: imageOverlayColor,
                  borderRadius: borderRadius,
                ),
              ),
            ),

          // Child content
          child,
        ],
      ),
    );

    // Apply border radius clipping if specified (and not using circle)
    if (borderRadius != null && circleRadius == null) {
      content = ClipRSuperellipse(borderRadius: borderRadius!, child: content);
    }

    // Apply circular clipping if circleRadius is specified
    if (circleRadius != null) {
      content = ClipOval(child: content);
    }

    return content;
  }

  Widget _buildBackgroundImage() {
    if (circleRadius != null) {
      return AppCircleImage(
        imageSource,
        radius: circleRadius!,
        placeholder: placeholder,
        errorWidget: errorWidget,
        fallbackImage: fallbackImagePath,
        fit: fit,
        clip: false,
        backgroundColor: backgroundColor,
      );
    }

    return AppImage(
      imageSource,
      width: width ?? defaultWidth,
      height: height ?? defaultHeight,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      fallbackImage: fallbackImagePath,
      borderRadius: null,
      backgroundColor: backgroundColor,
    );
  }
}
