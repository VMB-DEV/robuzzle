import 'package:flutter/material.dart';

import '../log/consolColors.dart';

class SlideDetector extends StatefulWidget {
  final child;
  final VoidCallback? slideDown;
  final VoidCallback? slideUp;
  final VoidCallback? slideRight;
  final VoidCallback? slideLeft;

  const SlideDetector({
    required this.child,
    this.slideDown,
    this.slideUp,
    this.slideRight,
    this.slideLeft,
    super.key,
  });

  @override
  State<SlideDetector> createState() => _State();
}

class _State extends State<SlideDetector> {
  double startY = 0;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        setState(() => startY = details.globalPosition.dy);
      },
      onVerticalDragEnd: (detail) {
        double delta = detail.globalPosition.dy - startY;
        if (delta > 50) {
          widget.slideDown?.call();
        }
      },
      onVerticalDragCancel: () { },
      onVerticalDragDown: (details) {
      },
      child: widget.child,
    );
  }
}
