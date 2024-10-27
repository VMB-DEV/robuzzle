import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardPainter extends CustomPainter {
  final bool finished;
  CardPainter({super.repaint, required this.finished});
  
  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      //todo : redondant blur ???
      ..shader = LinearGradient(
        begin: Alignment.topCenter ,
        end: Alignment.bottomRight,
        colors: [
          finished
              ? Colors.greenAccent.shade700
              // ? Colors.orangeAccent.shade700
              : Colors.tealAccent.shade700,
          Colors.teal.shade900.withOpacity(0.2),
        ],
      ).createShader( Rect.fromLTWH(0, 0, size.width, size.height))
      ..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.clamp)
    ;

    final innerBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..shader = LinearGradient(
        begin: Alignment.topCenter ,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withOpacity(0.7),
          Colors.grey.withOpacity(0.05),
        ],
      ).createShader( Rect.fromLTWH(0, 0, size.width, size.height))
    ;

    final Rrect = RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.elliptical(15, 25));
    canvas.drawRRect( Rrect, borderPaint );
    canvas.drawRRect( Rrect, innerBorderPaint, );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
