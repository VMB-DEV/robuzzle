import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/offset.dart';
import 'package:robuzzle/core/extensions/path.dart';

import '../page_level.dart';

class FunctionBackgroundPainter extends CustomPainter {
  final int totalItems;
  final int functionNumber;
  final int maxItemPerRow;
  // final List<int> functionShape;
  static const double cornerRadius = 5;
  const FunctionBackgroundPainter({super.repaint, required this.functionNumber, required this.totalItems, required this.maxItemPerRow});
      // : functionShape = const <int>[];

  int get _getNumberOfRows => (totalItems / maxItemPerRow).ceil();
  int _getRowLength(int index) => _isRowLast(index) ? _lastRowLength(index) : maxItemPerRow;
  bool _isRowLast(int index) => (totalItems - (index * maxItemPerRow)) / maxItemPerRow < 1.0;
  int _lastRowLength(int index) => (totalItems - (index * maxItemPerRow)) % maxItemPerRow;
  bool get firstAndSecondRowNotFlush => totalItems < 2 * maxItemPerRow;

  void _firstRowTopLeftCorner(Path path, Offset textTopRight, Offset topRight, Offset topLeft) {
    if (textTopRight.dy - topRight.dy < 2 * cornerRadius) {
      final newCornerRadius = (textTopRight.dy - topRight.dy) / 2;
      // path.roundCornerTopLeft(topLeft, newCornerRadius, clockwise: true);
      path.moveToOffset(topLeft, dy: newCornerRadius);
      path.arcToPoint(
          Offset(topLeft.dx + newCornerRadius, topLeft.dy),
          radius: const Radius.circular(cornerRadius),
          clockwise: true
      );
    } else {
      path.moveTo(topLeft.dx, topLeft.dy + cornerRadius);
      path.arcToPoint(
          Offset(topLeft.dx + cornerRadius, topLeft.dy),
          radius: const Radius.circular(cornerRadius),
          clockwise: true
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final listRowLength = List.generate(_getNumberOfRows, _getRowLength);
    final maxRowNumber = listRowLength.length;

    const double marge = 1.5;
    final bool secondRow = maxRowNumber >= 2;
    final bool thirdRow = maxRowNumber == 3;
    final double firstRowWidth = secondRow ? boxSizeStatic * maxItemPerRow + marge : boxSizeStatic * totalItems + marge;
    final double secondRowWidth = thirdRow ? (boxSizeStatic * maxItemPerRow) + marge : (totalItems - maxItemPerRow) * boxSizeStatic + marge;
    final double thirdRowWidth = thirdRow ? (totalItems - 2 * maxItemPerRow) * boxSizeStatic + marge : 0;
    const double minWidth = -marge;
    const double minHeight = -marge;
    double firstRowHeight = boxSizeStatic + marge;
    final topLeft = Offset(minWidth, minHeight);
    final topRight = Offset(firstRowWidth, minHeight);
    final firstRowBotRight = Offset(topRight.dx, firstRowHeight);
    final firstRowBotLeft = Offset(topLeft.dx, firstRowHeight);
    final secondRowHeight = 2 * firstRowHeight - marge;
    final secondRowTopRight = Offset(secondRowWidth, firstRowHeight);
    final secondRowBotRight = Offset(secondRowWidth, secondRowHeight);
    final secondRowBotLeft = Offset(topLeft.dx, secondRowHeight);
    final thirdRowHeight = 3 * firstRowHeight - 2 * marge;
    final thirdRowTopRight = Offset(thirdRowWidth, secondRowHeight);
    final thirdRowBotRight = Offset(thirdRowWidth, thirdRowHeight);
    final thirdRowBotLeft = Offset(topLeft.dx , thirdRowHeight);
    final botLeft = Offset(minWidth, thirdRow ? 3 * firstRowHeight : secondRow ? 2 * firstRowHeight : firstRowHeight);

    //todo : put these eleement in a inherited class ? paint strokewidth ...
    final paintBorderInner = Paint()
     .. color = Colors.teal.shade600
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    final paintBorderOuter = Paint()
      ..color = Colors.tealAccent.shade700
      ..strokeWidth = 1.7
      ..style = PaintingStyle.stroke
      ..imageFilter = ImageFilter.blur(sigmaX: 2, sigmaY: 2, tileMode: TileMode.clamp)
    ;

    final paintFill = Paint()
      ..color = Colors.blueGrey
      ..style = PaintingStyle.fill;
    final path = Path();

    String text = 'F$functionNumber';
    const textStyle = TextStyle( fontSize: 16, fontWeight: FontWeight.normal, );

    final outlineTextSpan = TextSpan(
      text: text,
      style: textStyle.copyWith(
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..color = Colors.black,
      ),
    );
    final outlineTextPainter = TextPainter(
      text: outlineTextSpan,
      textDirection: TextDirection.ltr,
    );
    final fillTextSpan = TextSpan(
      text: text,
      style: textStyle.copyWith(color: Colors.white),
    );
    final fillTextPainter = TextPainter(
      text: fillTextSpan,
      textDirection: TextDirection.ltr,
    );

    outlineTextPainter.layout(minWidth: 0, maxWidth: size.width);
    fillTextPainter.layout(minWidth: 0, maxWidth: size.width);

    const textPaddingEnd = 5;
    const textPaddingStart = 3;
    const textPaddingVertical = 3;
    final offset = Offset( - outlineTextPainter.width - textPaddingEnd, (size.height - outlineTextPainter.height) / 2, );
    final halfHeight = size.height / 2;
    final halfWidth = size.width / 2;
    final textHalfHeight = outlineTextPainter.height / 2;
    final textHalfWidth = outlineTextPainter.width / 2;

    final textTopLeft = Offset(-textPaddingStart - textPaddingEnd - outlineTextPainter.width - marge, halfHeight - textHalfHeight - textPaddingVertical);
    final textTopRight = Offset(0 - marge, textTopLeft.dy);
    final textBotRight = Offset(textTopRight.dx, halfHeight + textHalfHeight + textPaddingVertical);
    final textBotLeft = Offset(textTopLeft.dx, textBotRight.dy);

    // First row - Top Left
    _firstRowTopLeftCorner(path, textTopRight, topRight, topLeft);
    // // First row - Top Right
    path.roundCornerTopRight(topRight, cornerRadius, clockwise: true);
    // _firstRowTopRightCorner(path, topRight);
    if (maxRowNumber == 1) {
      // First row - Bot Right
      path.roundCornerBotRight(firstRowBotRight, cornerRadius, clockwise: true);
      // First row - Bot Left
      path.roundCornerBotLeft(firstRowBotLeft, cornerRadius, clockwise: true);
    }
    if (maxRowNumber > 1) {
      if (firstAndSecondRowNotFlush) {
        // First row - Bot Right
        path.roundCornerBotRight(firstRowBotRight, cornerRadius, clockwise: true);
        // Second row - Top Right
        path.roundCornerTopLeft(secondRowTopRight, cornerRadius, clockwise: false);
      }
      // Second row - Bot Right
      path.roundCornerBotRight(secondRowBotRight, cornerRadius, clockwise: true);
    }
    if (maxRowNumber == 2) {
      // Second row - Bot Left
      path.roundCornerBotLeft(secondRowBotLeft, cornerRadius, clockwise: true);
    }
    if (maxRowNumber == 3) {
      // Third row - Top Right
      path.roundCornerTopLeft(thirdRowTopRight, cornerRadius, clockwise: false);
      // Third row - Bot Left
      path.roundCornerBotRight(thirdRowBotRight, cornerRadius, clockwise: true);
      // Third row - Bot Left
      path.roundCornerBotLeft(thirdRowBotLeft, cornerRadius, clockwise: true);
    }

    if (botLeft.dy - textBotRight.dy < 2 * cornerRadius) {
      final newCornerRadius = (botLeft.dy - textBotRight.dy) / 2;
      path.arcToPoint( textBotRight.minusX(newCornerRadius), radius: Radius.circular(newCornerRadius), clockwise: false, );
      path.roundCornerBotLeft(textBotLeft, cornerRadius, clockwise: true);
      path.roundCornerTopLeft(textTopLeft, cornerRadius, clockwise: true);
      path.roundCornerBotRight(textTopRight, newCornerRadius, clockwise: false);
    } else {
      path.roundCornerTopRight(textBotRight, cornerRadius, clockwise: false);
      path.roundCornerBotLeft(textBotLeft, cornerRadius, clockwise: true);
      path.roundCornerTopLeft(textTopLeft, cornerRadius, clockwise: true);
      path.roundCornerBotRight(textTopRight, cornerRadius, clockwise: false);
    }
    path.close();

    canvas.drawPath( path, paintBorderOuter);
    canvas.drawPath( path, paintFill);
    canvas.drawPath( path, paintBorderInner);
    outlineTextPainter.paint(canvas, offset);
    fillTextPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
