import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_level.dart';

class LevelTitleWidget extends StatelessWidget {
  final LevelEntity level;
  const LevelTitleWidget({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${level.id}: ${level.title}",
              style: _titleStyle(box),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "${level.about}",
              style: _subtitleStyle(box),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        );
      }
    );
  }

  TextStyle _titleStyle(BoxConstraints box) => TextStyle(
    color: Colors.white,
    fontSize: box.H * 0.4,
    shadows: const [ Shadow(
      offset: Offset(1.2, 1.2),
      blurRadius: 5.0,
      color: Colors.black87,
    ),],
  );

  TextStyle _subtitleStyle(BoxConstraints box) => TextStyle(
    color: Colors.grey.shade700,
    fontSize: box.H * 0.25,
    shadows: const [
      Shadow(
        offset: Offset(1.2, 1.2),
        blurRadius: 5.0,
        color: Colors.black87,
      ),
    ],
  );
}
