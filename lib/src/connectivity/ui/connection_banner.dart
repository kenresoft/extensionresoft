import 'package:flutter/material.dart';

import 'connection_banner_style.dart';

class ConnectionBanner extends StatefulWidget {
  final String message;
  final ConnectionBannerStyle style;
  final VoidCallback onClose;

  const ConnectionBanner({
    super.key,
    required this.message,
    this.style = const ConnectionBannerStyle(),
    required this.onClose,
  });

  @override
  State<ConnectionBanner> createState() => _ConnectionBannerState();
}

class _ConnectionBannerState extends State<ConnectionBanner> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.style.animationDuration, vsync: this);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward(); // Start the animation when the banner is shown
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        elevation: 4.0,
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.9,
          height: widget.style.height,
          margin: const EdgeInsets.only(top: 40),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: widget.style.backgroundColor,
            borderRadius: BorderRadius.circular(widget.style.borderRadius),
            boxShadow:
                widget.style.boxShadow ??
                [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.style.icon, color: widget.style.iconColor, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.message,
                  style: widget.style.textStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: widget.style.iconColor, size: 24),
                onPressed: () {
                  _controller.reverse().then(
                    (_) => widget.onClose(),
                  ); // Dismiss animation before closing
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
