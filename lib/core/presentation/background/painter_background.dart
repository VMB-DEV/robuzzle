import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/offset.dart';
import 'package:robuzzle/core/extensions/path.dart';
import 'package:robuzzle/core/log/consolColors.dart';

class BackgroundPainter extends CustomPainter {
  const BackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Log.grey('BackgroundPainter.paint - ');
    const Offset screenTopLeft = Offset(0, 0);
    final Offset screenBotLeft = Offset(0, size.height);
    final Offset screenBotRight = Offset(size.width, size.height);
    final Offset screenTopRight = Offset(size.width, 0);
    final Offset center = size.center(screenBotRight);
    final fullRect =  Rect.fromLTWH(0, 0, size.width, size.height);

    final Paint mainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomCenter,
        colors: [ Colors.blueGrey.shade900, Colors.black38, ],
      ).createShader(fullRect);
    canvas.drawRect(fullRect, mainPaint);
    _drawBottomLeftPyramid(canvas, size);
  }

  _drawTopLeftPyramid(Canvas canvas, Size size) {
    const Offset screenTopLeft = Offset(0, 0);

    final Offset topPyramid = screenTopLeft.plusY(119).plusX(300);
    final Offset botLeftPyramid = screenTopLeft.minusY(50).plusX(150);
    final Offset botMiddlePyramid = screenTopLeft.minusY(100).plusX(450);
    final Offset botRightPyramid = screenTopLeft.minusY(50).plusX(500);

    final Offset topLeftDeltaPyramid = topPyramid.minusY(4).plusX(1);
    final Offset topRightDeltaPyramid = topPyramid.minusY(4).plusX(5);

    final Offset blackLightSource = topPyramid.minusY(70).plusX(130);
    final Offset otherLightSource = topPyramid.minusY(150).minusX(100);


    final Paint pyramidLeftFacePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        colors: [
          Colors.blueGrey.shade500,
          Colors.black
        ],
      ).createShader( Rect.fromCircle(center: otherLightSource, radius: 300), );
    final Paint pyramidRightFacePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        colors: [
          Colors.black38,
          Colors.blueGrey.shade800,
        ],
      ).createShader( Rect.fromCircle(center: blackLightSource, radius: 150), );

    final pyramidLeftFacePath = Path()
      ..moveToOffset(topPyramid)
      ..lineToOffset(botMiddlePyramid)
      ..lineToOffset(botLeftPyramid);
    final pyramidRightFacePath = Path()
      ..moveToOffset(topPyramid)
      ..lineToOffset(botMiddlePyramid)
      ..lineToOffset(botRightPyramid);
    final pyramidRightDeltaFacePath = Path()
      ..moveToOffset(topRightDeltaPyramid)
      ..lineToOffset(botMiddlePyramid)
      ..lineToOffset(botRightPyramid);
    final pyramidLeftDeltaFacePath = Path()
      ..moveToOffset(topLeftDeltaPyramid)
      ..lineToOffset(botMiddlePyramid)
      ..lineToOffset(botLeftPyramid);

    canvas.drawPath(pyramidLeftFacePath, pyramidLeftFacePaint);
    canvas.drawPath(pyramidRightFacePath, pyramidRightFacePaint);

    canvas.drawPath(pyramidLeftDeltaFacePath, pyramidLeftFacePaint..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.clamp));
    canvas.drawPath(pyramidRightDeltaFacePath, pyramidRightFacePaint..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.clamp));

    canvas.drawPath(pyramidLeftFacePath, _pyramidBorderPaint);
    canvas.drawPath(pyramidRightFacePath, _pyramidBorderPaint);
  }

  _drawBottomLeftPyramid(Canvas canvas, Size size) {
    final Offset screenBotLeft = Offset(0, size.height);

    final Offset topPyramid = screenBotLeft.minusY(200).plusX(150);
    final Offset botLeftPyramid = screenBotLeft.plusY(50).minusX(130);
    final Offset botMiddlePyramid = screenBotLeft.plusY(100).minusX(50);
    final Offset botRightPyramid = screenBotLeft.plusY(50).plusX(500);

    final Offset topDeltaFrontPyramid = topPyramid.plusY(5).plusX(2);
    final Offset topDeltaHiddenPyramid = topPyramid.plusY(20).minusX(20);

    final Paint pyramidFrontFacePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.blueGrey.shade600,
          Colors.black
        ],
      ).createShader( Rect.fromCircle(center: topPyramid, radius: 300), );
    final Paint pyramidHiddenFacePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.center,
        end: Alignment.centerRight,
        colors: [
          Colors.blueGrey.shade500,
          Colors.blueGrey.shade900,
        ],
        // ).createShader( Rect.fromCircle(center: screenBotLeft, radius: 100), );
      ).createShader( Rect.fromCircle(center: screenBotLeft, radius: 120), );

    final pyramidDeltaHiddenFacePath = Path()
      ..moveToOffset(topDeltaHiddenPyramid)
      ..lineToOffset(botLeftPyramid)
      ..lineToOffset(botMiddlePyramid)
      ..close();
    final pyramidDeltaFrontFacePath = Path()
      ..moveToOffset(topDeltaFrontPyramid)
      ..lineToOffset(botRightPyramid)
      ..lineToOffset(botMiddlePyramid)
      ..close();

    final pyramidFrontFacePath = Path()
      ..moveToOffset(topPyramid)
      ..lineToOffset(botRightPyramid)
      ..lineToOffset(botMiddlePyramid)
      ..close();

    final pyramidHiddenFacePath = Path()
      ..moveToOffset(topPyramid)
      ..lineToOffset(botMiddlePyramid)
      ..lineToOffset(botLeftPyramid)
      ..close();

    canvas.drawPath(pyramidHiddenFacePath, pyramidHiddenFacePaint);
    canvas.drawPath(pyramidFrontFacePath, pyramidFrontFacePaint);
    canvas.drawPath(pyramidDeltaHiddenFacePath, pyramidHiddenFacePaint..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.clamp));
    canvas.drawPath(pyramidDeltaFrontFacePath, pyramidFrontFacePaint..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.clamp));
    canvas.drawPath(pyramidFrontFacePath, _pyramidBorderPaint);
    canvas.drawPath(pyramidHiddenFacePath, _pyramidBorderPaint);
    canvas.drawPath(pyramidHiddenFacePath, _pyramidBorderPaint..strokeWidth = 0.5 );
  }

  Paint get _pyramidBorderPaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.6
    ..color = Colors.teal.shade800
    ..imageFilter = ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5, tileMode: TileMode.clamp)
  ;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}