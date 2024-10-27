import 'dart:ui';

import 'package:robuzzle/core/extensions/offset.dart';

extension PathExtension on Path {
  void moveToOffset(Offset offset, {double? dx, double? dy}) {
    moveTo(
      dx == null ? offset.dx : offset.dx + dx,
      dy == null ? offset.dy : offset.dy + dy,
    );
  }
  void lineToOffset(Offset offset, {double? dx, double? dy}) {
    lineTo(
      dx == null ? offset.dx : offset.dx + dx,
      dy == null ? offset.dy : offset.dy + dy,
    );
  }
  void roundCornerTopRight(Offset cornerOffset, double cornerRadius, {required bool clockwise}) {
    lineToOffset(clockwise ? cornerOffset.minusX(cornerRadius) : cornerOffset.plusY(cornerRadius));
    arcToPoint(
      radius: Radius.circular(cornerRadius),
      clockwise: clockwise,
      clockwise
          ? cornerOffset.plusY(cornerRadius)
          : cornerOffset.minusX(cornerRadius),
    );
  }
  void roundCornerTopLeft(Offset cornerOffset, double cornerRadius, {required bool clockwise}) {
    lineToOffset(clockwise ? cornerOffset.plusY(cornerRadius) : cornerOffset.plusX(cornerRadius));
    arcToPoint(
      radius: Radius.circular(cornerRadius),
      clockwise: clockwise,
      clockwise
          ? cornerOffset.plusX(cornerRadius)
          : cornerOffset.plusY(cornerRadius),
    );
  }
  void roundCornerBotLeft(Offset cornerOffset, double cornerRadius, {required bool clockwise}) {
    lineToOffset(clockwise ? cornerOffset.plusX(cornerRadius) : cornerOffset.minusY(cornerRadius));
    arcToPoint(
      radius: Radius.circular(cornerRadius),
      clockwise: clockwise,
      clockwise
          ? cornerOffset.minusY(cornerRadius)
          : cornerOffset.plusX(cornerRadius),
    );
  }
  void roundCornerBotRight(Offset cornerOffset, double cornerRadius, {required bool clockwise}) {
    lineToOffset(clockwise ? cornerOffset.minusY(cornerRadius) : cornerOffset.minusX(cornerRadius));
    arcToPoint(
      radius: Radius.circular(cornerRadius),
      clockwise: clockwise,
      clockwise
          ? cornerOffset.minusX(cornerRadius)
          : cornerOffset.minusY(cornerRadius),
    );
  }
  void roundCorner(Offset cornerOffset, double cornerRadius, bool clockwise, {bool? top, bool? bot, bool? right, bool? left}) {
    if ((top != null && bot != null) || (left != null && right != null)) throw Exception('roundCorner ERROR : corner can not be top and bot or left and right');
    if ((right == null && left == null) || (top == null && bot == null)) throw Exception('roundCorner ERROR : need to choose a corner vertically and horizontally');

    if (top == true) {
      if (right == true) {
        roundCornerTopRight(cornerOffset, cornerRadius, clockwise: clockwise);
      } else if ( left == true) {
        roundCornerTopLeft(cornerOffset, cornerRadius, clockwise: clockwise);
      }
    } else if (bot == true) {
      if (right == true) {
        roundCornerBotRight(cornerOffset, cornerRadius, clockwise: clockwise);
      } else if ( left == true) {
        roundCornerBotLeft(cornerOffset, cornerRadius, clockwise: clockwise);
      }
    }
  }
}
