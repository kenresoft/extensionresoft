import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utility/logger.dart';

/// A reusable widget for displaying images with network and asset fallbacks.
/// Supports error handling, placeholders, and decoration images.
class AppImage extends StatelessWidget {
  final String? image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? assetFallback;

  const AppImage(
    this.image, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.assetFallback,
  });

  @override
  Widget build(BuildContext context) {
    if (_isNetworkImage(image)) {
      return _buildCachedNetworkImage();
    }
    return _buildAssetImage();
  }

  /// Checks if the provided image path is a network URL.
  bool _isNetworkImage(String? image) {
    return image != null && Uri.tryParse(image)?.hasAbsolutePath == true;
    // return image != null && (image.startsWith('http://') || image.startsWith('https://')); legacy code
  }

  /// Builds an asset-based image with optional fallback on error.
  Widget _buildAssetImage() {
    return Image.asset(
      image ?? '',
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        if (assetFallback != null) {
          return Image.asset(
            assetFallback!,
            width: width,
            height: height,
            fit: fit,
          );
        }
        return _defaultErrorWidget();
      },
    );
  }

  /// Builds a cached network image with placeholders and error widgets.
  Widget _buildCachedNetworkImage() {
    return CachedNetworkImage(
      imageUrl: image ?? '',
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _defaultErrorWidget(),
    );
  }

  /// Default widget displayed while the image is loading.
  Widget _defaultPlaceholder() {
    return Center(
      child: SizedBox(
        width: 24.0,
        height: 24.0,
        child: const CircularProgressIndicator(),
      ),
    );
  }

  /// Default widget displayed when an error occurs while loading the image.
  Widget _defaultErrorWidget() {
    return Center(
      child: Icon(
        Icons.broken_image,
        color: Colors.grey.shade400,
        size: (width ?? 50.0) * 0.5,
      ),
    );
  }

  /// Converts the current image into a [DecorationImage] with robust error handling and fallbacks.
  DecorationImage toDecorationImage({
    BoxFit fit = BoxFit.cover,
    Alignment alignment = Alignment.center,
    ColorFilter? colorFilter,
    String? fallbackAsset,
    String defaultFallbackNetworkImage = 'https://via.placeholder.com/150',
  }) {
    assert(
      fallbackAsset != null || defaultFallbackNetworkImage.isNotEmpty,
      'At least one fallback image (asset or network) must be provided.',
    );

    try {
      if (_isNetworkImage(image)) {
        // Handle network image with fallback
        return DecorationImage(
          image: CachedNetworkImageProvider(image!),
          fit: fit,
          alignment: alignment,
          colorFilter: colorFilter,
          onError: (exception, stackTrace) {
            logger.e('Error loading network image: $exception',
                stackTrace: stackTrace);
          },
        );
      } else if (image != null && image!.isNotEmpty) {
        // Handle asset image
        return DecorationImage(
          image: AssetImage(image!),
          fit: fit,
          alignment: alignment,
          colorFilter: colorFilter,
        );
      } else if (fallbackAsset != null) {
        // Use provided fallback asset
        return DecorationImage(
          image: AssetImage(fallbackAsset),
          fit: fit,
          alignment: alignment,
          colorFilter: colorFilter,
        );
      } else {
        // Default to a network placeholder as the final fallback
        // logger.w('Invalid image provided. Using default network fallback.');
        return DecorationImage(
          image: CachedNetworkImageProvider(defaultFallbackNetworkImage),
          fit: fit,
          alignment: alignment,
          colorFilter: colorFilter,
        );
      }
    } catch (e, stackTrace) {
      // Comprehensive fallback for unexpected errors
      logger.e('Unexpected error in toDecorationImage: $e',
          error: e, stackTrace: stackTrace);
      return DecorationImage(
        image: fallbackAsset != null
            ? AssetImage(fallbackAsset) as ImageProvider
            : CachedNetworkImageProvider(defaultFallbackNetworkImage),
        fit: fit,
        alignment: alignment,
        colorFilter: colorFilter,
      );
    }
  }
}
