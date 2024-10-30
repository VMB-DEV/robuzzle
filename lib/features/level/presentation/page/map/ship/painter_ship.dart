import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/path.dart';

class ShipPainter extends CustomPainter {
  final double animationValue;

  ShipPainter(this.animationValue);


  @override
  void paint(Canvas canvas, Size size) {
    final double maxWidth = size.width * 0.9;
    final double strokeWidth = size.width * 0.025;
    final double minWidth = size.width * 0.2;
    final double maxHeight = size.height * 0.85;
    final double minHeight = size.height * 0.15;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final Offset bottom = Offset(size.width * 0.3, centerY);
    final double outerRadius = size.width / 3;
    final Offset center = Offset(centerX, centerY);
    final Color outerFireColor = Color.lerp(
        Colors.white70.withOpacity(0.001),
        Colors.white70.withOpacity(0.4),
        animationValue
    )!;
    final Color startColor = Color.lerp(
        Colors.grey.shade800,
        Colors.grey.shade500,
        animationValue
    )!;
    final Color endColor = Color.lerp(
        Colors.grey.shade500,
        Colors.grey.shade800,
        animationValue
    )!;

    final Paint shipOutlineLeft = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        end: Alignment.centerRight,
        begin: Alignment.topLeft,
        colors: [ startColor, endColor ],
      ).createShader( Rect.fromCircle(center: center, radius: centerX), );
    final Paint shipOutlineRight = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = LinearGradient(
        end: Alignment.centerRight,
        begin: Alignment.bottomLeft,
        colors: [ startColor, endColor ],
      ).createShader( Rect.fromCircle(center: center, radius: centerX), );
    final Paint gradientPaintRight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomLeft,
        colors: [ Colors.grey.shade300, Colors.grey.shade600 ],
      ).createShader( Rect.fromCircle(center: center, radius: centerX), );
    final Paint gradientPaintLeft = Paint()
      ..shader = LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topLeft,
        colors: [ Colors.grey.shade400, Colors.grey.shade700, ],
      ).createShader( Rect.fromCircle(center: center, radius: centerX), );
    final Paint gradientPaintFireOuter = Paint()
      ..shader = LinearGradient(
        begin: Alignment.center,
        end: Alignment.centerLeft,
        colors: [ outerFireColor, Colors.transparent.withOpacity(0.001)],
      ).createShader( Rect.fromCircle(center: bottom, radius: outerRadius), );

    final pathLeft = Path();
    pathLeft.moveTo( minWidth, minHeight );
    pathLeft.lineTo( maxWidth, centerY);
    pathLeft.lineToOffset(bottom);
    pathLeft.close();
    final pathRight = Path();
    pathRight.moveTo( minWidth, maxHeight );
    pathRight.lineTo( maxWidth, centerY);
    pathRight.lineToOffset(bottom);
    pathRight.close();

    const startAngle2 = 108 * (pi / 180);
    const endAngle2 = 252 * (pi / 180);
    const sweepAngle2 = endAngle2 - startAngle2;
    final pathOuterFire = Path();
    const useCenter = false;
    pathOuterFire.moveToOffset(bottom);
    pathOuterFire.arcTo( Rect.fromCircle(center: bottom, radius: outerRadius), startAngle2, sweepAngle2, useCenter);
    pathOuterFire.close();

    canvas.drawPath( pathOuterFire, gradientPaintFireOuter);
    canvas.drawPath( pathLeft, gradientPaintLeft);
    canvas.drawPath( pathLeft, shipOutlineLeft);
    canvas.drawPath( pathRight, gradientPaintRight);
    canvas.drawPath( pathRight, shipOutlineRight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
