import 'package:flutter/material.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_level.dart';

class LevelTitleWidget extends StatelessWidget {
  final LevelEntity level;
  const LevelTitleWidget({required this.level, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${level.id}: ${level.title}",
          style: _titleStyle,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          "${level.about}",
          style: _subtitleStyle,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  TextStyle get _titleStyle => const TextStyle(
    color: Colors.white,
    fontSize: 15,
    shadows: [ Shadow(
      offset: Offset(1.2, 1.2),
      blurRadius: 5.0,
      color: Colors.black87,
    ),],
  );

  TextStyle get _subtitleStyle => TextStyle(
    color: Colors.grey.shade700,
    fontSize: 12,
    shadows: const [
      Shadow(
        offset: Offset(1.2, 1.2),
        blurRadius: 5.0,
        color: Colors.black87,
      ),
    ],
  );
}
