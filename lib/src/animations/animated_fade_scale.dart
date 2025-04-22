import 'package:flutter/material.dart';

class AnimatedFadeScale extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double beginScale;
  final double endScale;
  final double? value;

  const AnimatedFadeScale({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.delay = Duration.zero,
    this.curve = Curves.easeInOut,
    this.beginScale = 0.92,
    this.endScale = 1.0,
    this.value,
  });

  @override
  State<AnimatedFadeScale> createState() => _AnimatedFadeScaleState();
}

class _AnimatedFadeScaleState extends State<AnimatedFadeScale> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      debugLabel: 'AnimatedFadeScale',
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: widget.beginScale,
      end: widget.endScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    if (widget.value != null) {
      _controller.value = widget.value!;
    } else {
      void startAnimation() {
        if (mounted) _controller.forward(from: 0);
      }

      if (widget.delay != Duration.zero) {
        Future.delayed(widget.delay, startAnimation);
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) => startAnimation());
      }
    }
  }

  @override
  void didUpdateWidget(AnimatedFadeScale oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.child != widget.child || oldWidget.value != widget.value) {
      if (widget.value != null) {
        _controller.value = widget.value!;
      } else {
        _controller.reset();
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Material(
        type: MaterialType.transparency,
        child: widget.child,
      ),
    );
  }
}
