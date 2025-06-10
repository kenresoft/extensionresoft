// Copyright 2023 kenresoft. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class CustomRatingBar extends StatefulWidget {
  /// Initial rating value
  final double initialRating;

  /// Maximum possible rating
  final int maxRating;

  /// Size of each rating icon
  final double iconSize;

  /// Function called when rating changes
  final Function(double)? onRatingChanged;

  /// Icon to display for rating
  final IconData activeIcon;

  /// Icon to display for unrated portion
  final IconData inactiveIcon;

  /// Color of the active rating icons
  final Color activeColor;

  /// Color of the inactive rating icons
  final Color inactiveColor;

  /// Spacing between icons
  final double spacing;

  /// Whether half ratings are allowed
  final bool allowHalfRating;

  /// Whether the rating can be updated by user interaction
  final bool isInteractive;

  /// Whether to show rating text
  final bool showRatingText;

  /// Text style for rating text
  final TextStyle? ratingTextStyle;

  /// Animation duration for rating changes
  final Duration animationDuration;

  /// Custom content builder for rating items
  final Widget Function(BuildContext, int, bool, double)? itemBuilder;

  /// Direction of the rating bar
  final Axis direction;

  const CustomRatingBar({
    super.key,
    this.initialRating = 0.0,
    this.maxRating = 5,
    this.iconSize = 24.0,
    this.onRatingChanged,
    this.activeIcon = Icons.star,
    this.inactiveIcon = Icons.star_border,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
    this.spacing = 4.0,
    this.allowHalfRating = true,
    this.isInteractive = true,
    this.showRatingText = false,
    this.ratingTextStyle,
    this.animationDuration = const Duration(milliseconds: 300),
    this.itemBuilder,
    this.direction = Axis.horizontal,
  });

  @override
  State<CustomRatingBar> createState() => _CustomRatingBarState();
}

class _CustomRatingBarState extends State<CustomRatingBar>
    with SingleTickerProviderStateMixin {
  late double _rating;
  late AnimationController _controller;
  late Animation<double> _animation;
  final List<GlobalKey> _starKeys = [];

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating.clamp(0.0, widget.maxRating.toDouble());

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: _rating,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    // Initialize star keys
    _updateStarKeys();
  }

  void _updateStarKeys() {
    _starKeys.clear();
    for (int i = 0; i < widget.maxRating; i++) {
      _starKeys.add(GlobalKey());
    }
  }

  @override
  void didUpdateWidget(CustomRatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.maxRating != widget.maxRating) {
      _updateStarKeys();
    }

    if (oldWidget.initialRating != widget.initialRating) {
      _rating = widget.initialRating.clamp(0.0, widget.maxRating.toDouble());
      _animation = Tween<double>(
        begin: _animation.value,
        end: _rating,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Accurately determine which star was touched and whether it was a half or full rating
  double _calculateRatingFromTouch(Offset globalPosition) {
    // Identify which star was touched by checking bounds of each star widget
    for (int i = 0; i < _starKeys.length; i++) {
      final key = _starKeys[i];
      final box = key.currentContext?.findRenderObject() as RenderBox?;

      if (box != null) {
        final starPosition = box.localToGlobal(Offset.zero);
        final starSize = box.size;

        // Check if touch is within this star's bounds
        final touchWithinStarX =
            globalPosition.dx >= starPosition.dx &&
            globalPosition.dx <= starPosition.dx + starSize.width;
        final touchWithinStarY =
            globalPosition.dy >= starPosition.dy &&
            globalPosition.dy <= starPosition.dy + starSize.height;

        if (touchWithinStarX && touchWithinStarY) {
          // Calculate where within the star the touch occurred
          final positionInStar = widget.direction == Axis.horizontal
              ? (globalPosition.dx - starPosition.dx) / starSize.width
              : (globalPosition.dy - starPosition.dy) / starSize.height;

          // Determine if it's a half or full rating
          if (widget.allowHalfRating) {
            if (widget.direction == Axis.horizontal) {
              return positionInStar < 0.5 ? i + 0.5 : i + 1.0;
            } else {
              return positionInStar < 0.5 ? i + 0.5 : i + 1.0;
            }
          } else {
            return (i + 1).toDouble();
          }
        }
      }
    }

    // If we couldn't find a star that was directly touched,
    // find the closest star based on position
    return _findClosestRating(globalPosition);
  }

  double _findClosestRating(Offset globalPosition) {
    // Determine the position relative to the entire rating bar
    double closestDistance = double.infinity;
    double closestRating = 0;

    for (int i = 0; i < _starKeys.length; i++) {
      final key = _starKeys[i];
      final box = key.currentContext?.findRenderObject() as RenderBox?;

      if (box != null) {
        final starPosition = box.localToGlobal(Offset.zero);
        final starSize = box.size;
        final starCenter = Offset(
          starPosition.dx + starSize.width / 2,
          starPosition.dy + starSize.height / 2,
        );

        // Calculate distance to star center
        final distance = (globalPosition - starCenter).distance;

        if (distance < closestDistance) {
          closestDistance = distance;

          // If we allow half ratings, check if we're in the left or right half
          // of the closest star
          if (widget.allowHalfRating) {
            final positionRelativeToStar = widget.direction == Axis.horizontal
                ? globalPosition.dx - starPosition.dx
                : globalPosition.dy - starPosition.dy;

            final halfPoint = widget.direction == Axis.horizontal
                ? starSize.width / 2
                : starSize.height / 2;

            closestRating = positionRelativeToStar < halfPoint ? i + 0.5 : i + 1.0;
          } else {
            closestRating = (i + 1).toDouble();
          }
        }
      }
    }

    return closestRating.clamp(0.0, widget.maxRating.toDouble());
  }

  void _updateRating(double newRating) {
    // Ensure the rating stays in bounds
    newRating = newRating.clamp(0.0, widget.maxRating.toDouble());

    if (_rating != newRating) {
      setState(() {
        _rating = newRating;
        _animation = Tween<double>(
          begin: _animation.value,
          end: _rating,
        ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
        _controller.forward(from: 0.0);
      });

      if (widget.onRatingChanged != null) {
        widget.onRatingChanged!(_rating);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onHorizontalDragStart:
                  widget.isInteractive && widget.direction == Axis.horizontal
                  ? (details) {
                      _updateRating(
                        _calculateRatingFromTouch(details.globalPosition),
                      );
                    }
                  : null,
              onHorizontalDragUpdate:
                  widget.isInteractive && widget.direction == Axis.horizontal
                  ? (details) {
                      _updateRating(
                        _calculateRatingFromTouch(details.globalPosition),
                      );
                    }
                  : null,
              onVerticalDragStart:
                  widget.isInteractive && widget.direction == Axis.vertical
                  ? (details) {
                      _updateRating(
                        _calculateRatingFromTouch(details.globalPosition),
                      );
                    }
                  : null,
              onVerticalDragUpdate:
                  widget.isInteractive && widget.direction == Axis.vertical
                  ? (details) {
                      _updateRating(
                        _calculateRatingFromTouch(details.globalPosition),
                      );
                    }
                  : null,
              onTapDown: widget.isInteractive
                  ? (details) {
                      _updateRating(
                        _calculateRatingFromTouch(details.globalPosition),
                      );
                    }
                  : null,
              child: MouseRegion(
                cursor: widget.isInteractive
                    ? SystemMouseCursors.click
                    : MouseCursor.defer,
                child: Flex(
                  direction: widget.direction,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(widget.maxRating, (index) {
                    return Container(
                      key: _starKeys[index],
                      margin: EdgeInsets.symmetric(
                        horizontal: widget.direction == Axis.horizontal
                            ? widget.spacing / 2
                            : 0,
                        vertical: widget.direction == Axis.vertical
                            ? widget.spacing / 2
                            : 0,
                      ),
                      child: _buildRatingItem(index + 1),
                    );
                  }),
                ),
              ),
            ),
            if (widget.showRatingText)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _animation.value.toStringAsFixed(widget.allowHalfRating ? 1 : 0),
                  style:
                      widget.ratingTextStyle ??
                      Theme.of(context).textTheme.bodyLarge,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildRatingItem(int position) {
    final double fillLevel = (_animation.value - (position - 1)).clamp(0.0, 1.0);
    final bool isActive = position <= _animation.value;

    if (widget.itemBuilder != null) {
      return SizedBox(
        width: widget.iconSize,
        height: widget.iconSize,
        child: widget.itemBuilder!(context, position, isActive, fillLevel),
      );
    }

    return SizedBox(
      width: widget.iconSize,
      height: widget.iconSize,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Icon(
            widget.inactiveIcon,
            size: widget.iconSize,
            color: widget.inactiveColor,
          ),
          ClipRect(
            clipper: _RatingClipper(fillLevel, widget.direction),
            child: Icon(
              widget.activeIcon,
              size: widget.iconSize,
              color: widget.activeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingClipper extends CustomClipper<Rect> {
  final double fillLevel;
  final Axis direction;

  _RatingClipper(this.fillLevel, this.direction);

  @override
  Rect getClip(Size size) {
    if (direction == Axis.horizontal) {
      return Rect.fromLTRB(0, 0, size.width * fillLevel, size.height);
    } else {
      return Rect.fromLTRB(0, 0, size.width, size.height * fillLevel);
    }
  }

  @override
  bool shouldReclip(_RatingClipper oldClipper) {
    return fillLevel != oldClipper.fillLevel || direction != oldClipper.direction;
  }
}
