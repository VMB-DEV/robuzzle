import 'package:flutter/material.dart';
import '../../../domain/entities/progress/action/entity_action.dart';
import '../../../domain/entities/progress/action/entity_case_color.dart';

//Todo : INT hard coded
class ActionCase extends StatelessWidget {
  final ActionEntity action;
  final bool whiteBorders;
  final int size;
  final bool darkFilter;
  // final Function() onTap;
  final VoidCallback? onTap;

  const ActionCase({
    required this.action,
    required this.size,
    // required this.onTap,
    this.onTap,
    this.whiteBorders = false,
    this.darkFilter = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(1),
      child: GestureDetector(
        onTap: onTap ?? () {},
        child:
        Stack(
          children: [
            Container(
              width: size - 2,
              height: size - 2,
              decoration: BoxDecoration(
                color: switch (action.color) {
                  CaseColorEntity.red => Colors.black,
                  CaseColorEntity.blue => Colors.blue,
                  CaseColorEntity.green => Colors.green,
                  CaseColorEntity.grey => Colors.grey,
                  CaseColorEntity.none => Colors.black,
                },
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: switch (action.color) {
                      CaseColorEntity.red => [ Colors.red.shade700, Colors.red.shade700, Colors.red.shade700, Colors.red.shade600, Colors.red.shade400,],
                      CaseColorEntity.blue => [ Colors.indigo.shade700, Colors.indigo, Colors.blue.shade600 ],
                      CaseColorEntity.green => [Colors.teal.shade800, Colors.green.shade700],
                      CaseColorEntity.grey => [Colors.grey , Colors.grey , Colors.grey.shade400],
                      CaseColorEntity.none => [Colors.black, Colors.black],
                    }
                ),
                border: Border.all(
                  color: whiteBorders ? Colors.white : Colors.black,
                  width: whiteBorders ? 1 : 0.5,
                ),
                borderRadius: BorderRadius.circular(3.5),
              ),
            ),
            SizedBox(
              width: size - 2,
              height: size - 2,
              child: Center(
                child: Stack(
                  children: [
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 18,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 2
                          ..color = Colors.black.withOpacity(0.3),
                      ),
                      child: Text('${action.instruction}'),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 18,
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 0.8
                          ..color = Colors.black,
                      ),
                      child: Text('${action.instruction}'),
                    ),
                    DefaultTextStyle(
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        child: Text('${action.instruction}'),
                    ),
                  ],
                ),
              ),
            ),
            if (darkFilter) Container(
              width: size - 2,
              height: size - 2,
              decoration: BoxDecoration(
                color: Colors.black54.withOpacity(0.35),
                border: Border.all(
                  color: whiteBorders ? Colors.white : Colors.black,
                  width: whiteBorders ? 1 : 0.5,
                ),
                borderRadius: BorderRadius.circular(3.5),
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class ActionCasePaint extends StatelessWidget {
  final ActionEntity action;
  final bool whiteBorders;
  final int size;
  final VoidCallback? onTap;

  const ActionCasePaint({
    required this.action,
    required this.size,
    this.onTap,
    this.whiteBorders = false,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: CustomPaint(
        // size: Size(size.toDouble(), size.toDouble()),
        size: const Size(1, 1),
        painter: ActionCasePainter(
          action: action,
          whiteBorders: whiteBorders,
        ),
      ),
    );
  }
}

class ActionCasePainter extends CustomPainter {
  final ActionEntity action;
  final bool whiteBorders;

  const ActionCasePainter({required this.action, required this.whiteBorders});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final borderRadius = BorderRadius.circular(3.5);

    // Draw gradient background
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: _getColors(),
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRRect(borderRadius.toRRect(rect), paint);

    // Draw border
    final borderPaint = Paint()
      ..color = whiteBorders ? Colors.white : Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = whiteBorders ? 1 : 0.5;
    canvas.drawRRect(borderRadius.toRRect(rect), borderPaint);

    // Draw text
    _drawText(canvas, size);
  }

  List<Color> _getColors() {
    switch (action.color) {
      case CaseColorEntity.red:
        return [Colors.red.shade700, Colors.red.shade700, Colors.red.shade700, Colors.red.shade600, Colors.red.shade400];
      case CaseColorEntity.blue:
        return [Colors.indigo.shade700, Colors.indigo, Colors.blue.shade600];
      case CaseColorEntity.green:
        return [Colors.teal.shade800, Colors.green.shade700];
      case CaseColorEntity.grey:
        return [Colors.grey, Colors.grey, Colors.grey.shade400];
      case CaseColorEntity.none:
        return [Colors.black];
    }
  }

  void _drawText(Canvas canvas, Size size) {
    final textSpan = TextSpan(
      text: action.instruction.toString(),
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Draw text shadow
    final shadowTextPainter = TextPainter(
      text: TextSpan(
        text: action.instruction.toString(),
        style: TextStyle(
          fontSize: 18,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.black.withOpacity(0.3),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    shadowTextPainter.layout();
    shadowTextPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2));

    // Draw text outline
    final outlineTextPainter = TextPainter(
      text: TextSpan(
        text: action.instruction.toString(),
        style: TextStyle(
          fontSize: 18,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 0.8
            ..color = Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    outlineTextPainter.layout();
    outlineTextPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2));

    // Draw main text
    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! ActionCasePainter ||
        oldDelegate.action != action ||
        oldDelegate.whiteBorders != whiteBorders;
  }
}
