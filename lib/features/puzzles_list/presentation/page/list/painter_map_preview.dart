import 'package:flutter/material.dart';

class MapPreviewPainter extends CustomPainter {
  List<String> rows;
  MapPreviewPainter(this.rows);

  final paintRed = Paint()..color = Colors.red.withOpacity(0.8);
  final paintGreen = Paint()..color = Colors.green.withOpacity(0.8);
  final paintBlue = Paint()..color = Colors.indigo.withOpacity(0.8);
  final paintOrange = Paint()..color = Colors.orange;

  @override
  void paint(Canvas canvas, Size size) {
    final double boxSize = rows.length > rows.first.length ? size.width / rows.length : size.width / rows.first.length;
    for (final (rowNumber, row) in rows.indexed) {
      final rowChar = row.split('');
      final top = rowNumber * boxSize;
      for (final (colNumber, caseLetter) in rowChar.indexed) {
        final left = colNumber * boxSize;
        if (caseLetter != ' ') {
          final rect = Rect.fromLTWH(left, top, boxSize, boxSize);
          canvas.drawRRect(
            RRect.fromRectAndRadius(rect, const Radius.circular(4)),
            paintPicker(caseLetter),
          );
        }
      }
    }
  }

  Paint paintPicker(String caseLetter) => switch (caseLetter) {
    'r' || 'R' => paintRed,
    'b' || 'B' => paintBlue,
    'g' || 'G' => paintGreen,
    String() => paintOrange
  };

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

