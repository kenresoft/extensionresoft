import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A theme class to customize the range slider's colors.
class CustomRangeSliderTheme {
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;
  final Color? overlayColor;
  final Color? thumbBorderColor;

  const CustomRangeSliderTheme({
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.overlayColor,
    this.thumbBorderColor,
  });
}

/// A highly customizable dual-handle range slider widget.
class CustomRangeSlider extends StatefulWidget {
  /// The current range values.
  final RangeValues values;

  /// Called when the user is actively dragging the thumbs.
  final ValueChanged<RangeValues> onChanged;

  /// Called when the user is done dragging a thumb.
  final ValueChanged<RangeValues>? onChangeEnd;

  /// The minimum value of the range.
  final double min;

  /// The maximum value of the range.
  final double max;

  /// The number of discrete divisions. Set to null for continuous.
  final int? divisions;

  /// The height of the slider track.
  final double trackHeight;

  /// The radius of the thumb handles.
  final double thumbRadius;

  /// The custom color theme for the slider.
  final CustomRangeSliderTheme? customTheme;

  /// Enables haptic feedback on value changes.
  final bool enableHaptics;

  /// A custom formatter for the accessibility labels.
  final String Function(double value)? semanticFormatter;

  const CustomRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.trackHeight = 2.0,
    this.thumbRadius = 20.0,
    this.customTheme,
    this.enableHaptics = true,
    this.semanticFormatter,
  }) : assert(min <= max, 'min must be less than or equal to max');

  /// Factory constructor that validates values and clamps them if needed
  factory CustomRangeSlider.safe({
    Key? key,
    required RangeValues values,
    required ValueChanged<RangeValues> onChanged,
    ValueChanged<RangeValues>? onChangeEnd,
    double min = 0.0,
    double max = 1.0,
    int? divisions,
    double trackHeight = 2.0,
    double thumbRadius = 20.0,
    CustomRangeSliderTheme? customTheme,
    bool enableHaptics = true,
    String Function(double value)? semanticFormatter,
  }) {
    // Validate and clamp values to ensure they're within bounds
    final clampedStart = math.max(min, math.min(max, values.start));
    final clampedEnd = math.max(min, math.min(max, values.end));
    final safeValues = RangeValues(
      math.min(clampedStart, clampedEnd),
      math.max(clampedStart, clampedEnd),
    );

    return CustomRangeSlider(
      key: key,
      values: safeValues,
      onChanged: onChanged,
      onChangeEnd: onChangeEnd,
      min: min,
      max: max,
      divisions: divisions,
      trackHeight: trackHeight,
      thumbRadius: thumbRadius,
      customTheme: customTheme,
      enableHaptics: enableHaptics,
      semanticFormatter: semanticFormatter,
    );
  }

  @override
  State<CustomRangeSlider> createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late ValueNotifier<RangeValues> _currentValuesNotifier;

  @override
  void initState() {
    super.initState();

    // Validate and sanitize values at runtime
    _currentValuesNotifier = ValueNotifier<RangeValues>(_sanitizeValues(widget.values));

    _animationController = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(CustomRangeSlider oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-validate when widget updates
    if (widget.values != oldWidget.values ||
        widget.min != oldWidget.min ||
        widget.max != oldWidget.max) {
      _currentValuesNotifier.value = _sanitizeValues(widget.values);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _currentValuesNotifier.dispose();
    super.dispose();
  }

  /// Sanitizes and validates the range values to ensure they're within bounds
  RangeValues _sanitizeValues(RangeValues values) {
    // Clamp values to min/max bounds
    final clampedStart = math.max(widget.min, math.min(widget.max, values.start));
    final clampedEnd = math.max(widget.min, math.min(widget.max, values.end));

    // Ensure start <= end
    return RangeValues(math.min(clampedStart, clampedEnd), math.max(clampedStart, clampedEnd));
  }

  void _handleDragStart() {
    _animationController.forward();
    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
  }

  void _handleDragEnd() {
    _animationController.reverse();
    widget.onChangeEnd?.call(_currentValuesNotifier.value);
    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  RangeValues _discretizeValues(RangeValues values) {
    if (widget.divisions == null) {
      return values;
    }

    final stepSize = (widget.max - widget.min) / widget.divisions!;
    final discreteStart = (values.start / stepSize).round() * stepSize;
    final discreteEnd = (values.end / stepSize).round() * stepSize;

    return RangeValues(math.max(widget.min, discreteStart), math.min(widget.max, discreteEnd));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sliderTheme = SliderTheme.of(context);

    // Resolve colors from custom theme or fallback to Material Design 3
    final activeColor = widget.customTheme?.activeTrackColor ?? colorScheme.primary;
    final inactiveColor =
        widget.customTheme?.inactiveTrackColor ?? colorScheme.outline.withValues(alpha: 0.3);
    final thumbColor = widget.customTheme?.thumbColor ?? Colors.white;
    final overlayColor = widget.customTheme?.overlayColor ?? activeColor.withValues(alpha: 0.1);
    final borderColor = widget.customTheme?.thumbBorderColor ?? activeColor;

    return ValueListenableBuilder<RangeValues>(
      valueListenable: _currentValuesNotifier,
      builder: (context, currentValues, child) {
        return Material(
          color: Colors.transparent,
          child: SizedBox(
            height: math.max(widget.thumbRadius * 2, 40),
            child: SliderTheme(
              data: sliderTheme.copyWith(
                trackHeight: widget.trackHeight,
                activeTrackColor: activeColor,
                inactiveTrackColor: inactiveColor,
                thumbColor: thumbColor,
                overlayColor: overlayColor,
                rangeThumbShape: _CustomRangeThumbShape(
                  radius: widget.thumbRadius,
                  scaleAnimation: _scaleAnimation,
                  borderColor: borderColor,
                ),
                overlayShape: RoundSliderOverlayShape(overlayRadius: widget.thumbRadius * 1.5),
                trackShape: _CustomTrackShape(trackHeight: widget.trackHeight),
              ),
              child: RangeSlider(
                values: currentValues,
                min: widget.min,
                max: widget.max,
                divisions: widget.divisions,
                onChanged: (values) {
                  final sanitizedValues = _sanitizeValues(values);
                  final discretizedValues = _discretizeValues(sanitizedValues);
                  _currentValuesNotifier.value = discretizedValues;
                  widget.onChanged(discretizedValues);
                },
                onChangeStart: (_) => _handleDragStart(),
                onChangeEnd: (_) => _handleDragEnd(),
                semanticFormatterCallback: widget.semanticFormatter,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CustomRangeThumbShape extends RangeSliderThumbShape {
  final double radius;
  final Animation<double> scaleAnimation;
  final Color borderColor;

  const _CustomRangeThumbShape({
    required this.radius,
    required this.scaleAnimation,
    required this.borderColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool isOnTop = false,
    bool isPressed = false,
    required SliderThemeData sliderTheme,
    TextDirection textDirection = TextDirection.ltr,
    Thumb thumb = Thumb.start,
  }) {
    final canvas = context.canvas;
    final scale = isPressed ? scaleAnimation.value : 1.0;
    final scaledRadius = radius * scale;

    // Main thumb with Material 3 styling
    final thumbPaint = Paint()
      ..color = sliderTheme.thumbColor!
      ..style = PaintingStyle.fill;

    // Material Design 3 elevation shadow with dynamic depth
    final shadowPath = Path()..addOval(Rect.fromCircle(center: center, radius: scaledRadius));
    canvas.drawShadow(shadowPath, Colors.black, isPressed ? 4.0 : 2.0, true);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, scaledRadius, thumbPaint);
    canvas.drawCircle(center, scaledRadius, borderPaint);

    // Subtle inner highlight
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, scaledRadius * 0.4, highlightPaint);
  }
}

class _CustomTrackShape extends SliderTrackShape with BaseSliderTrackShape {
  final double trackHeight;

  const _CustomTrackShape({required this.trackHeight});

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final trackWidth = parentBox.size.width;

    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required Offset thumbCenter,
    Offset? secondaryOffset,
    bool isDiscrete = false,
    bool isEnabled = false,
  }) {
    if (secondaryOffset != null) {
      final rect = getPreferredRect(
        parentBox: parentBox,
        offset: offset,
        sliderTheme: sliderTheme,
        isEnabled: isEnabled,
        isDiscrete: isDiscrete,
      );

      final canvas = context.canvas;
      final trackRadius = rect.height / 2;

      final inactivePaint = Paint()..color = sliderTheme.inactiveTrackColor!;
      final activePaint = Paint()..color = sliderTheme.activeTrackColor!;

      // Full inactive track with rounded ends
      final inactiveTrackRRect = RRect.fromRectAndRadius(rect, Radius.circular(trackRadius));
      canvas.drawRRect(inactiveTrackRRect, inactivePaint);

      // Active track segment between thumbs
      final activeTrackRect = Rect.fromLTRB(
        math.min(thumbCenter.dx, secondaryOffset.dx),
        rect.top,
        math.max(thumbCenter.dx, secondaryOffset.dx),
        rect.bottom,
      );
      final activeTrackRRect = RRect.fromRectAndRadius(activeTrackRect, Radius.circular(trackRadius));
      canvas.drawRRect(activeTrackRRect, activePaint);
    }
  }
}
