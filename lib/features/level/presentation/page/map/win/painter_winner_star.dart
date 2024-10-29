import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class WinnerStarPainter extends CustomPainter {
  final double animationValue;

  WinnerStarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double outerRadius = size.height * 0.27;
    final double innerRadius = outerRadius * 0.45;
    final Color starColor = Color.lerp(
        Colors.yellow.shade600,
        Colors.yellow.shade400,
        animationValue
    )!;

    final Paint starGlowPaint = Paint()
      ..color=starColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15 * animationValue
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
    ;

    final Path starPath = Path();
    for (int i = 0; i < 5; i++) {
      // Outer point
      double outerX = centerX + outerRadius * cos(2 * pi * i / 5 - pi / 2);
      double outerY = centerY + outerRadius * sin(2 * pi * i / 5 - pi / 2);

      // Inner point
      double innerX = centerX + innerRadius * cos(2 * pi * (i + 0.5) / 5 - pi / 2);
      double innerY = centerY + innerRadius * sin(2 * pi * (i + 0.5) / 5 - pi / 2);

      if (i == 0) {
        starPath.moveTo(outerX, outerY);
      } else {
        starPath.lineTo(outerX, outerY);
      }
      starPath.lineTo(innerX, innerY);
    }
    starPath.close();
    canvas.drawPath(starPath, starGlowPaint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
