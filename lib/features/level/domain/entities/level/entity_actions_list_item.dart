import 'package:robuzzle/features/level/domain/entities/level/entity_ship.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_action.dart';

import '../puzzle/entity_map.dart';
import '../puzzle/entity_position.dart';

class ActionListItemEntity {
  final ActionEntity action;
  final PositionEntity actionPosition;
  final MapEntity map;

  ActionListItemEntity({
    required this.action,
    required this.actionPosition,
    required this.map,
  });

  ActionListItemEntity copyWith({
    ActionEntity? action,
    PositionEntity? actionPosition,
    ShipEntity? ship,
    MapEntity? map,
  }) => ActionListItemEntity(
    action: action?.copy ?? this.action.copy,
    actionPosition: actionPosition?.copy ?? this.actionPosition.copy,
    map: map?.copy ?? this.map.copy
  );

  ActionListItemEntity get copy => copyWith();

  @override
  String toString() { return '${map.ship} $actionPosition $action'; }
}