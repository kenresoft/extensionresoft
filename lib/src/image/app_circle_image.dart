import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A reusable widget for displaying circular images with network and asset fallbacks.
/// Provides support for error handling, placeholders, and fallback images.
class AppCircleImage extends StatelessWidget {
  final String? image;
  final double radius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final String? assetFallback;

  const AppCircleImage(
    this.image, {
    super.key,
    this.radius = 30.0,
    this.placeholder,
    this.errorWidget,
    this.assetFallback,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: _isNetworkImage(image)
            ? _buildCachedNetworkImage()
            : _buildAssetImage(),
      ),
    );
  }

  /// Checks if the provided image path is a network URL.
  bool _isNetworkImage(String? image) {
    return image != null && Uri.tryParse(image)?.hasAbsolutePath == true;
  }

  /// Builds an asset-based image with an optional fallback on error.
  Widget _buildAssetImage() {
    return Image.asset(
      image ?? '',
      width: radius * 2,
      height: radius * 2,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        if (assetFallback != null) {
          return Image.asset(
            assetFallback!,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
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
      width: radius * 2,
      height: radius * 2,
      fit: BoxFit.cover,
      placeholder: (context, url) => placeholder ?? _defaultPlaceholder(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _defaultErrorWidget(),
    );
  }

  /// Default widget displayed while the image is loading.
  Widget _defaultPlaceholder() {
    return Center(
      child: SizedBox(
        width: radius,
        height: radius,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey.shade400),
        ),
      ),
    );
  }

  /// Default widget displayed when an error occurs while loading the image.
  Widget _defaultErrorWidget() {
    return Center(
      child: Icon(
        Icons.person,
        size: radius,
        color: Colors.grey.shade500,
      ),
    );
  }
}
