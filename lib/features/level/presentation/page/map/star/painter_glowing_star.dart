import 'dart:math';

import 'package:flutter/material.dart';

class StarPainter extends CustomPainter {
  final double animationValue;

  StarPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final Offset center = Offset(centerX , centerY);
    final double outerRadius = size.width * 0.27;
    final double innerRadius = outerRadius * 0.45;
    final double glowRadius = size.width;
    final Color starGlowStart = Color.lerp(
        Colors.yellow.shade700,
        Colors.yellow.shade600,
        animationValue
    )!;
    final Color starGlowEnd = Color.lerp(
        Colors.yellow.shade300,
        Colors.yellow.shade100,
        animationValue
    )!;
    final Color auraGlow = Color.lerp(
        Colors.yellow.shade600.withOpacity(0.001),
        Colors.yellow.shade600,
        animationValue
    )!;

    // final Paint starPaint = Paint()
    //   ..shader = RadialGradient(
    //     center: Alignment.center,
    //     radius: 0.5,
    //     colors: [
    //       starGlowEnd,
    //       starGlowStart,
    //     ],
    //     stops: [0.0, 1.0],
    //   ).createShader(Rect.fromCircle(
    //     center: Offset(centerX, centerY),
    //     radius: outerRadius,
    //   ));
    final Paint starGlowPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 1,
        colors: [
          Colors.white.withOpacity(0.0001),
          auraGlow,
          // Colors.transparent
        ],
        stops: [0.0, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: innerRadius,
        // radius: glowRadius,
      ));
    // final Paint auraGlowPaint2 = Paint()
    //   ..shader = RadialGradient(
    //     center: Alignment.center,
    //     radius: 1,
    //     colors: [
    //       auraGlow,
    //       Colors.white.withOpacity(0.0001),
    //     ],
    //     stops: const [0.0, 1.0],
    //   ).createShader(Rect.fromCircle(
    //     center: Offset(centerX, centerY),
    //     radius: innerRadius,
    //     // radius: glowRadius,
    //   ))
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 2.6
    //   ..strokeCap = StrokeCap.round
    //   ..strokeJoin = StrokeJoin.round;
    // ;



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


    // canvas.drawPath(starPath, auraGlowPaint2);
    // canvas.drawPath(starPath, starPaint);
    canvas.drawPath(starPath, starGlowPaint);
  }


  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
