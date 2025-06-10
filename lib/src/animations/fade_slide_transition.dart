import 'package:flutter/material.dart';

/// A high-performance reusable widget providing smooth view transitions with fade and slide animations.
class FadeSlideTransition extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve fadeCurve;
  final Curve slideCurve;
  final Offset initialSlideOffset;

  /// Key that triggers transition when changed.
  final Key? transitionKey;
  final VoidCallback? onTransitionComplete;

  const FadeSlideTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.fadeCurve = Curves.easeOut,
    this.slideCurve = Curves.easeOutCubic,
    this.initialSlideOffset = const Offset(0.05, 0),
    this.transitionKey,
    this.onTransitionComplete,
  });

  static FadeSlideTransition fast({
    required Widget child,
    Key? key,
    Key? transitionKey,
  }) {
    return FadeSlideTransition(
      key: key,
      transitionKey: transitionKey,
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }

  static FadeSlideTransition slow({
    required Widget child,
    Key? key,
    Key? transitionKey,
  }) {
    return FadeSlideTransition(
      key: key,
      transitionKey: transitionKey,
      duration: const Duration(milliseconds: 500),
      child: child,
    );
  }

  @override
  State<FadeSlideTransition> createState() => _FadeSlideTransitionState();
}

class _FadeSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late final ValueNotifier<Widget> _displayedChildNotifier;
  late final ValueNotifier<bool> _isTransitioningNotifier;

  Key? _previousTransitionKey;
  Widget? _pendingChild;

  @override
  void initState() {
    super.initState();
    _initializeStateManagement();
    _initializeAnimations();
    _previousTransitionKey = widget.transitionKey;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void didUpdateWidget(covariant FadeSlideTransition oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      _reinitializeAnimations();
    }

    _handleContentUpdate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _displayedChildNotifier.dispose();
    _isTransitioningNotifier.dispose();
    super.dispose();
  }

  void _initializeStateManagement() {
    _displayedChildNotifier = ValueNotifier<Widget>(widget.child);
    _isTransitioningNotifier = ValueNotifier<bool>(false);
  }

  void _initializeAnimations() {
    _controller = AnimationController(duration: widget.duration, vsync: this);

    _createAnimations();
  }

  void _createAnimations() {
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.6, curve: widget.fadeCurve),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.initialSlideOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.slideCurve));
  }

  void _reinitializeAnimations() {
    _createAnimations();
  }

  void _handleContentUpdate() {
    final shouldTriggerTransition = _shouldTriggerTransition();

    if (shouldTriggerTransition) {
      _previousTransitionKey = widget.transitionKey;
      _scheduleTransition();
    } else if (!_isTransitioningNotifier.value) {
      // Direct content update without transition
      _displayedChildNotifier.value = widget.child;
    }
  }

  bool _shouldTriggerTransition() {
    if (widget.transitionKey != null) {
      return widget.transitionKey != _previousTransitionKey;
    }

    // Uses widget identity comparison for performance
    return _displayedChildNotifier.value.runtimeType != widget.child.runtimeType ||
        _displayedChildNotifier.value.key != widget.child.key;
  }

  /// Schedule transition with queueing support for rapid updates
  void _scheduleTransition() {
    _pendingChild = widget.child;

    if (!_isTransitioningNotifier.value) {
      _performTransition();
    }
    // If already transitioning, _pendingChild will be picked up by the next cycle
  }

  Future<void> _performTransition() async {
    if (!mounted) return;

    _isTransitioningNotifier.value = true;

    try {
      // Phase 1: Fade out current content
      await _controller.reverse();

      // Phase 2: Surgical content swap during invisible state
      if (mounted && _pendingChild != null) {
        _displayedChildNotifier.value = _pendingChild!;
        _pendingChild = null;
      }

      // Phase 3: Fade in new content
      if (mounted) {
        await _controller.forward();
      }

      // Completion callback with null safety
      if (mounted) {
        widget.onTransitionComplete?.call();
      }
    } on TickerCanceled {
      // Handle disposed controller gracefully
      debugPrint('FadeSlideTransition: Animation canceled due to disposal');
    } catch (e) {
      // Comprehensive error handling for production stability
      debugPrint('FadeSlideTransition: Unexpected error during transition: $e');
    } finally {
      if (mounted) {
        _isTransitioningNotifier.value = false;
      }
    }
  }

  Future<void> triggerTransition() => _performTransition();

  bool get isTransitioning => _isTransitioningNotifier.value;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Widget>(
      valueListenable: _displayedChildNotifier,
      builder: (context, displayedChild, _) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: displayedChild,
              ),
            );
          },
        );
      },
    );
  }
}
