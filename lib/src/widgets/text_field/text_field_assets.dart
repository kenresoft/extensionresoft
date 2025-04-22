// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class _InternalAssets {
  const _InternalAssets._();

  static const String visibilityOn = 'assets/icons/password_visibility_on.png';
  static const String visibilityOff = 'assets/icons/password_visibility_off.png';
  static const String packageName = 'extensionresoft';
}

class AssetResolver {
  static Widget resolveVisibilityIcon({
    required bool isVisible,
    String? userAssetPath,
    required Color? color,
    required double size,
  }) {
    final packageAssetPath =
        isVisible ? _InternalAssets.visibilityOn : _InternalAssets.visibilityOff;

    return _ImageWithFallback(
      userAssetPath: userAssetPath,
      packageAssetPath: packageAssetPath,
      packageName: _InternalAssets.packageName,
      width: size,
      height: size,
      color: color,
      ultimateFallback: Icon(
        isVisible ? Icons.visibility : Icons.visibility_off,
        size: size,
        color: color,
      ),
    );
  }
}

class _ImageWithFallback extends StatelessWidget {
  final String? userAssetPath;
  final String packageAssetPath;
  final String packageName;
  final double? width;
  final double? height;
  final Color? color;
  final Widget ultimateFallback;

  const _ImageWithFallback({
    this.userAssetPath,
    required this.packageAssetPath,
    required this.packageName,
    this.width,
    this.height,
    this.color,
    required this.ultimateFallback,
  });

  @override
  Widget build(BuildContext context) {
    if (userAssetPath == null) {
      return _loadPackageAsset();
    }

    return Image.asset(
      userAssetPath!,
      width: width,
      height: height,
      color: color,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame != null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return _loadPackageAsset();
      },
    );
  }

  Widget _loadPackageAsset() {
    return Image.asset(
      packageAssetPath,
      package: packageName,
      width: width,
      height: height,
      color: color,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;
        return AnimatedOpacity(
          opacity: frame != null ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return ultimateFallback;
      },
    );
  }
}
