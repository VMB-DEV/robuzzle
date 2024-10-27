import 'package:flutter/material.dart';

import '../../../domain/entities/level/entity_actions_list_item.dart';
import '../../../domain/entities/progress/action/entity_action.dart';
import '../action_case/action_case.dart';

class ActionCaseListPainter extends CustomPainter {
  final List<ActionListItemEntity> list;
  final double widthPadding;
  final int caseSize;
  final double startPadding = 4.0;
  final double firstCaseEndPadding = 8.0;

  const ActionCaseListPainter({
    required this.list,
    this.widthPadding = 2.0,
    required this.caseSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (list.isEmpty) { return; }
    final clipPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.clipPath(clipPath);

    double currentX = startPadding;
    _addAction(borders: true, canvas, list[0].action, startPadding);

    if (list.length < 2) {
      return;
    }
    currentX += caseSize + firstCaseEndPadding;
    final listLoop = list.sublist(1);
    for (var item in listLoop) {
      if (currentX > size.width) break;
      _addAction(canvas, item.action, currentX);
      currentX += caseSize + widthPadding;
    }
  }

  void _addAction(Canvas canvas, ActionEntity action, double currentXStart, { bool borders = false}) {
    final actionPainter = ActionCasePainter(
      action: action,
      whiteBorders: borders,
    );
    canvas.save();
    canvas.translate(currentXStart, 0);
    actionPainter.paint(canvas, Size(caseSize.toDouble(), caseSize.toDouble()));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ActionCaseListPainter oldDelegate) {
    return false;
    // return oldDelegate.list != list
    //     || oldDelegate.widthPadding != widthPadding
    //     || oldDelegate.caseSize != caseSize;
  }
}