/*
import 'package:flutter/material.dart';

import 'connection_banner.dart';
import 'connection_banner_style.dart';

class ConnectionBannerManager extends StatefulWidget {
  final Widget child;

  const ConnectionBannerManager({super.key, required this.child});

  @override
  _ConnectionBannerManagerState createState() => _ConnectionBannerManagerState();
}

class _ConnectionBannerManagerState extends State<ConnectionBannerManager> {
  bool _isVisible = false;
  String _message = "No internet connection";
  ConnectionBannerStyle _style = ConnectionBannerStyle.offline();

  void showBanner({required String message, required ConnectionBannerStyle style}) {
    setState(() {
      _message = message;
      _style = style;
      _isVisible = true;
    });

    // Hide the banner after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Align(
          alignment: Alignment.topCenter,
          child: ConnectionBannerWidget(
            message: _message,
            style: _style,
            isVisible: _isVisible,
            onClose: () {
              setState(() {
                _isVisible = false;
              });
            },
          ),
        ),
      ],
    );
  }
}
*/
