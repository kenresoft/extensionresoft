// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Source type for the image
enum ImageSourceType { network, asset, file, none }

/// A reusable widget for displaying circular images with auto-detection for network, asset, and file sources.
/// Provides optimized handling with placeholders and fallbacks.
class AppCircleImage extends StatelessWidget {
  /// The image source - can be a network URL, asset path, or File object
  final dynamic image;
  final double radius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? fallbackImage;
  final BoxFit fit;
  final Color? backgroundColor;
  final Color? placeholderColor;

  /// Controls whether the image is clipped to a circle. Defaults to true.
  final bool clip;

  const AppCircleImage(
    this.image, {
    super.key,
    this.radius = 30.0,
    this.placeholder,
    this.errorWidget,
    this.fallbackImage,
    this.fit = BoxFit.cover,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.clip = true,
    this.placeholderColor,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = _buildImage(context);
    // final double size = radius * 2;

    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: clip ? ClipOval(child: imageWidget) : imageWidget,
      // : SizedBox(width: size, height: size, child: imageWidget),
    );
  }

  /// Determines the image source type
  ImageSourceType _getImageSourceType() {
    if (image == null) {
      return ImageSourceType.none;
    }

    if (image is File) {
      return ImageSourceType.file;
    }

    if (image is! String || (image as String).isEmpty) {
      return ImageSourceType.none;
    }

    if (_isNetworkImage(image as String)) {
      return ImageSourceType.network;
    }

    return ImageSourceType.asset;
  }

  /// Checks if the provided image path is a network URL.
  bool _isNetworkImage(String path) {
    // Primary check: starts with http:// or https://
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return true;
    }

    // Secondary check: using Uri parser for more complex cases
    final uri = Uri.tryParse(path);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  /// Builds the appropriate image widget based on source type
  Widget _buildImage(BuildContext context) {
    final imageSourceType = _getImageSourceType();
    final double size = radius * 2;

    switch (imageSourceType) {
      case ImageSourceType.network:
        return _buildCachedNetworkImage(size, context);
      case ImageSourceType.asset:
        return _buildAssetImage(size, context);
      case ImageSourceType.file:
        return _buildFileImage(size, context);
      case ImageSourceType.none:
        return _buildFallbackOrError(size, context);
    }
  }

  /// Builds a file image with error handling
  Widget _buildFileImage(double size, BuildContext context) {
    if (kIsWeb) return _buildFallbackOrError(size, context);
    return Image.file(
      image as File,
      width: size,
      height: size,
      fit: fit,
      cacheWidth: _calculateCacheWidth(size, context),
      errorBuilder: (context, error, stackTrace) => _buildFallbackOrError(size, context),
    );
  }

  /// Builds an asset-based image with error handling
  Widget _buildAssetImage(double size, BuildContext context) {
    return Image.asset(
      image as String,
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildFallbackOrError(size, context),
      cacheWidth: _calculateCacheWidth(size, context),
    );
  }

  /// Builds a cached network image with optimized settings
  Widget _buildCachedNetworkImage(double size, BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image as String,
      width: size,
      height: size,
      fit: fit,
      memCacheWidth: _calculateCacheWidth(size, context),
      placeholder: (context, url) => placeholder ?? _defaultPlaceholder(context),
      errorWidget: (context, url, error) => _buildFallbackOrError(size, context),
    );
  }

  /// Calculate appropriate cache width based on device pixel ratio
  int? _calculateCacheWidth(double size, BuildContext context) {
    if (size.isInfinite || size.isNaN || size <= 0) return null;
    try {
      final devicePixelRatio = kIsWeb ? 1.0 : MediaQuery.of(context).devicePixelRatio;
      final calculatedWidth = size * devicePixelRatio;
      if (calculatedWidth.isFinite && calculatedWidth > 0 && calculatedWidth < 10000) {
        return calculatedWidth.toInt();
      }
    } catch (_) {}
    return null;
  }

  /// Builds either a fallback image or error widget
  Widget _buildFallbackOrError(double size, BuildContext context) {
    if (fallbackImage != null) {
      return Image.asset(
        fallbackImage!,
        width: size,
        height: size,
        fit: fit,
        cacheWidth: _calculateCacheWidth(size, context),
        errorBuilder: (context, error, stackTrace) => errorWidget ?? _defaultErrorWidget(context),
      );
    }
    return errorWidget ?? _defaultErrorWidget(context);
  }

  /// Default widget displayed while the image is loading.
  Widget _defaultPlaceholder(BuildContext context) {
    final color = placeholderColor ?? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6);

    return Center(
      child: SizedBox(
        width: radius,
        height: radius,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }

  /// Default widget displayed when an error occurs while loading the image.
  Widget _defaultErrorWidget(BuildContext context) {
    final color = placeholderColor ?? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6);
    return Center(
      child: Icon(Icons.person, size: radius, color: color),
    );
  }
}
