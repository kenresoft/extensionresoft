// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_circle_image.dart' show ImageSourceType;

/// A versatile image widget supporting multiple source types with unified API.
/// Handles network URLs, asset paths, and File objects with built-in fallbacks.
class AppImage extends StatelessWidget {
  /// Image source - accepts String (URL/asset path) or File
  final dynamic image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? fallbackImage;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? placeholderColor;

  const AppImage(
    this.image, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fallbackImage,
    this.borderRadius,
    this.backgroundColor,
    this.placeholderColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = _buildImageBySourceType(context);

    // Apply border radius if specified
    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    // Wrap with Container for background color if specified
    if (backgroundColor != null) {
      return Container(color: backgroundColor, width: width, height: height, child: imageWidget);
    }

    return imageWidget;
  }

  /// Builds the appropriate image widget based on detected source type
  Widget _buildImageBySourceType(BuildContext context) {
    final sourceType = _getImageSourceType();

    switch (sourceType) {
      case ImageSourceType.network:
        return _buildCachedNetworkImage(context);
      case ImageSourceType.file:
        return _buildFileImage(context);
      case ImageSourceType.asset:
        return _buildAssetImage(context);
      case ImageSourceType.none:
        return _buildFallbackImage(context);
    }
  }

  /// Determines the image source type based on the provided image value
  ImageSourceType _getImageSourceType() {
    if (image == null) {
      return ImageSourceType.none;
    }

    if (image is File) {
      return ImageSourceType.file;
    }

    if (image is! String) {
      return ImageSourceType.none;
    }

    final String imagePath = (image as String).trim();
    if (imagePath.isEmpty) {
      return ImageSourceType.none;
    }

    if (_isNetworkImage(imagePath)) {
      return ImageSourceType.network;
    }

    return ImageSourceType.asset;
  }

  /// Checks if the provided image path is a network URL
  bool _isNetworkImage(String path) {
    // Primary check: starts with http:// or https://
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return true;
    }

    // Secondary check: using Uri parser for more complex cases
    final uri = Uri.tryParse(path);
    return uri != null && uri.hasScheme && uri.hasAuthority;
  }

  /// Builds a file-based image with error handling
  Widget _buildFileImage(BuildContext context) {
    if (kIsWeb) return _buildFallbackImage(context);
    return Image.file(
      image as File,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: _calculateCacheWidth(context),
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackImage(context);
      },
    );
  }

  /// Builds an asset-based image with error handling
  Widget _buildAssetImage(BuildContext context) {
    return Image.asset(
      image as String,
      width: width,
      height: height,
      fit: fit,
      cacheWidth: _calculateCacheWidth(context),
      errorBuilder: (context, error, stackTrace) {
        return _buildFallbackImage(context);
      },
    );
  }

  /// Builds a cached network image with optimized settings
  Widget _buildCachedNetworkImage(BuildContext context) {
    final imageUrl = (image as String).trim();

    if (kIsWeb) {
      return Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildFallbackImage(context),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _defaultPlaceholder(context);
        },
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: _calculateCacheWidth(context),
      placeholder: (context, url) => placeholder ?? _defaultPlaceholder(context),
      errorWidget: (context, url, error) {
        return _buildFallbackImage(context);
      },
    );
  }

  /// Builds the fallback image or error widget
  Widget _buildFallbackImage(BuildContext context) {
    if (fallbackImage != null && fallbackImage!.isNotEmpty) {
      return Image.asset(
        fallbackImage!,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: _calculateCacheWidth(context),
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _defaultErrorWidget();
        },
      );
    }
    return errorWidget ?? _defaultErrorWidget();
  }

  /// Calculate appropriate cache width based on device pixel ratio
  int? _calculateCacheWidth(BuildContext context) {
    if (kIsWeb || width == null || width!.isInfinite || width!.isNaN) return null;

    try {
      final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
      final calculatedWidth = width! * devicePixelRatio;

      // Ensure the value is finite and within reasonable bounds
      if (calculatedWidth.isFinite && calculatedWidth > 0 && calculatedWidth < 10000) {
        return calculatedWidth.toInt();
      }
      return null;
    } catch (e) {
      debugPrint('Error calculating cache width: $e');
      return null;
    }
  }

  /// Default placeholder widget while loading images
  Widget _defaultPlaceholder(BuildContext context) {
    final color = placeholderColor ?? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6);

    return Center(
      child: SizedBox(
        width: 24.0,
        height: 24.0,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }

  /// Default error widget when image loading fails
  Widget _defaultErrorWidget() {
    final double iconSize = (height != null && height! > 0 && height!.isFinite ? height! : 50.0) * 0.5;
    return Center(
      child: Icon(Icons.broken_image, color: Colors.grey.shade400, size: iconSize),
    );
  }

  /// Converts the current image into a [DecorationImage] with robust error handling and fallbacks.
  DecorationImage toDecorationImage({
    BoxFit? decorationFit,
    Alignment alignment = Alignment.center,
    ColorFilter? colorFilter,
    String fallbackAsset = 'assets/img.png',
    String defaultFallbackNetworkImage = 'https://picsum.photos/150',
  }) {
    assert(
      fallbackAsset.isNotEmpty || defaultFallbackNetworkImage.isNotEmpty,
      'At least one fallback image (asset or network) must be provided.',
    );

    try {
      final sourceType = _getImageSourceType();
      final BoxFit actualFit = decorationFit ?? fit;

      switch (sourceType) {
        case ImageSourceType.network:
          // Handle network image
          final imageUrl = (image as String).trim();
          return DecorationImage(
            image: kIsWeb ? NetworkImage(imageUrl) as ImageProvider : CachedNetworkImageProvider(imageUrl),
            fit: actualFit,
            alignment: alignment,
            colorFilter: colorFilter,
            onError: (exception, stackTrace) {
            },
          );

        case ImageSourceType.file:
          // Handle file image
          if (kIsWeb) {
            return DecorationImage(
              image: fallbackAsset.isNotEmpty
                  ? AssetImage(fallbackAsset, package: 'extensionresoft')
                  : NetworkImage(defaultFallbackNetworkImage) as ImageProvider,
              fit: actualFit,
              alignment: alignment,
              colorFilter: colorFilter,
            );
          }
          return DecorationImage(
            image: FileImage(image as File),
            fit: actualFit,
            alignment: alignment,
            colorFilter: colorFilter,
            onError: (exception, stackTrace) {},
          );

        case ImageSourceType.asset:
          // Handle asset image
          return DecorationImage(
            image: AssetImage(image as String),
            fit: actualFit,
            alignment: alignment,
            colorFilter: colorFilter,
            onError: (exception, stackTrace) {
            },
          );

        case ImageSourceType.none:
          // Use provided fallback
          if (fallbackAsset.isNotEmpty) {
            return DecorationImage(
              image: AssetImage(fallbackAsset, package: 'extensionresoft'),
              fit: actualFit,
              alignment: alignment,
              colorFilter: colorFilter,
            );
          } else {
            return DecorationImage(
              image: kIsWeb
                  ? NetworkImage(defaultFallbackNetworkImage) as ImageProvider
                  : CachedNetworkImageProvider(defaultFallbackNetworkImage),
              fit: actualFit,
              alignment: alignment,
              colorFilter: colorFilter,
            );
          }
      }
    } catch (e, stackTrace) {
      // Comprehensive fallback for unexpected errors
      debugPrint('Unexpected error in toDecorationImage: $e\n$stackTrace');

      return DecorationImage(
        image: fallbackAsset.isNotEmpty
            ? AssetImage(fallbackAsset, package: 'extensionresoft') as ImageProvider
            : (kIsWeb
                ? NetworkImage(defaultFallbackNetworkImage) as ImageProvider
                : CachedNetworkImageProvider(defaultFallbackNetworkImage)),
        fit: decorationFit ?? fit,
        alignment: alignment,
        colorFilter: colorFilter,
      );
    }
  }
}
