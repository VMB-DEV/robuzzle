import 'package:robuzzle/core/extensions/list.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_actions_list_item.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_level.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_path_result.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_ship.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_action.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_player_instruction.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_map.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_position.dart';

import '../../../../../core/log/consolColors.dart';

//Todo: String hard coded
class ActionsListEntity {
  MapEntity _originalMap;
  List<List<ActionEntity>> _functions;
  List<ActionListItemEntity> list;
  List<(int, int)> listIndexes;
  int _index = 0;
  int currentIndex = 0;
  int maxIndex = 1000;
  PathResultEntity result;


  PositionEntity get currentActionPosition => list.isNotEmpty ? list[currentIndex].actionPosition : PositionEntity.none();
  ActionEntity get currentAction => list[currentIndex].action;
  ActionListItemEntity get currentItem => list[currentIndex];
  MapEntity get currentMap => list.isNotEmpty ? list[currentIndex].map : _originalMap;
  ShipEntity get currentShip => list.isNotEmpty ? list[currentIndex].map.ship : _originalMap.ship;
  ActionListItemEntity get _lastItem => list.last;
  MapEntity get _lastMap => _lastItem.map;
  ShipEntity get _lastShip => _lastMap.ship;
  int get lastIndex => list.isNotEmpty ? list.length - 1 : 0;
  ActionsListEntity get copy => copyWith();

  ActionsListEntity({
    required MapEntity map,
    required List<List<ActionEntity>> functions,
  }) : _functions = functions,
        _originalMap = map.copy,
        result = PathResultEntity.onGoing,
        listIndexes = [],
        list = [],
        _index = 0,
        currentIndex = 0,
        // maxIndex = 20;
        // maxIndex = 50;
        maxIndex = 1000;

  factory ActionsListEntity.fromLevel(LevelEntity level) {
    var entity = ActionsListEntity(
      map: level.map.copy,
      functions: level.functions.values,
    );
    entity._initializeList(level.map.ship);
    return entity;
  }

  ActionsListEntity copyWith({
    MapEntity? map,
    MapEntity? currentMap,
    List<List<ActionEntity>>? functions,
    List<ActionListItemEntity>? list,
    List<(int, int)>? listIndexes,
    int? index,
    int? currentIndex,
    int? maxIndex,
  }) {
    return ActionsListEntity(
      map: map ?? _originalMap,
      functions: functions ?? _functions,
    )
      ..list = list ?? this.list.copy
      ..listIndexes = listIndexes ?? this.listIndexes.copy
      .._index = index ?? this._index
      ..currentIndex = currentIndex ?? this.currentIndex
      ..maxIndex = maxIndex ?? this.maxIndex
    ;
  }

  void _initializeList(ShipEntity ship) {
    list = [
      ActionListItemEntity(
        action: ActionEntity.firstAction,
        actionPosition: const PositionEntity(row: 0, col: -1),
        map: _originalMap.copy,
      ),
    ];
    _loopOnPositions(0);
  }

  void _countGroups() {
    if (list.isEmpty) throw Exception('ActionsListEntity._countGroups - list is empty');
    final groupsIndexes = <(int, int)>[];
    var count = 1;

    for (var i = 1; i < list.length; i++) {
      if (list[i].actionPosition.row == list[i].actionPosition.row) {
        count++;
      } else {
        groupsIndexes.add((i - count, i));
        count = 1;
      }
    }
    listIndexes = groupsIndexes;
  }

  void _loopOnPositions(int row) {
    ShipEntity ship = _lastItem.map.ship.copy;
    PositionEntity? actionPosition = PositionEntity(row: row, col: 0);

    while (actionPosition != null && _index < maxIndex && result.isGoingOn) {
      try {
        ActionEntity action = _functions[actionPosition.row][actionPosition.col];
        _index++;
        ship = _lastItem.map.ship.copy;
        if (action.isAction && _lastMap.isMapCaseMatchingColor(action, ship.pos)) {
          _readAction(actionPosition);
        }
        actionPosition = _nextActionPositionOrNull(actionPosition);
      } catch (e) {
        print(e);
        break;
      }
    }
  }

  PositionEntity? _nextActionPositionOrNull(PositionEntity? actionPosition) {
    if (actionPosition == null) return null;
    if (actionPosition.col < _functions[actionPosition.row].length - 1) {
      return actionPosition.copyWith(col: actionPosition.col + 1);
    } else {
      return null;
    }
  }

  void _readAction(PositionEntity actionPosition) {
    ActionEntity action = _functions[actionPosition.row][actionPosition.col];
    switch (action.instruction) {
      case PlayerInstructionEntity.goForward: _readMoving((action, actionPosition));
      case PlayerInstructionEntity.turnLeft
      || PlayerInstructionEntity.turnRight: _readTurn((action, actionPosition));
      case PlayerInstructionEntity.goToF0
      || PlayerInstructionEntity.goToF1
      || PlayerInstructionEntity.goToF2
      || PlayerInstructionEntity.goToF3
      || PlayerInstructionEntity.goToF4: _readFunction((action, actionPosition));
      case PlayerInstructionEntity.changeColorToRed
      || PlayerInstructionEntity.changeColorToGreen
      || PlayerInstructionEntity.changeColorToBlue: _readColorChange((action, actionPosition));
      case _: throw Exception('ActionListEntity - readAction - ERROR - action position ${_lastItem.actionPosition}');
    }
  }

  void _readMoving((ActionEntity, PositionEntity) action) {
    final ShipEntity newShip = _lastShip.movedForward;
    final MapEntity newMap = _lastMap.copyWith(ship: newShip);
    if (_lastMap.isOnValidCase(newShip.pos) && _lastMap.containStarAt(newShip.pos) ) {
      newMap.addOrRemoveStarAt(newShip.pos);
    }
    final listItem = ActionListItemEntity(
      action: action.$1.copy,
      actionPosition: action.$2.copy,
      map: newMap
    );
    list.add(listItem);
    _checkResult(_lastMap, newShip);
  }

  void _checkResult(MapEntity map, ShipEntity ship) {
    if (!map.isOnValidCase(ship.pos)) {
      result = PathResultEntity.loose;
      list.add(_lastItem);
    } else if (map.noStarsLeft) {
      result = PathResultEntity.win;
    }
  }

  void _readTurn((ActionEntity, PositionEntity) action) {
    ShipEntity newShip = switch (action.$1.instruction) {
      PlayerInstructionEntity.turnLeft => _lastShip.turnedLeft,
      PlayerInstructionEntity.turnRight => _lastShip.turnedRight,
      _ => throw Exception('ActionListEntity - _readTurn - ERROR')
    };
    ActionListItemEntity newListItem = ActionListItemEntity(
      action: action.$1.copy,
      actionPosition: action.$2.copy,
      map: _lastMap.copyWith(ship: newShip),
    );
    list.add(newListItem);
  }

  void _readFunction((ActionEntity, PositionEntity) action) {
    final listItem = _lastItem.copyWith(
      action: action.$1.copy,
      actionPosition: action.$2.copy,
    );
    list.add( listItem );
    _loopOnPositions(action.$1.instruction.functionNumber);
  }

  void _readColorChange((ActionEntity, PositionEntity) action) {
    final newMap = _lastMap.isOnValidCase(_lastShip.pos)
        ? _lastMap.copy.colorChangeAt(action.$1.instruction.getColorChange)
        : _lastMap.copy;
    final listItem = _lastItem.copyWith(
        action: action.$1.copy,
        actionPosition: action.$2.copy,
        map: newMap
    );
    list.add(listItem);
  }

  bool isWinIndex(int index) => index == lastIndex && list[index].map.noStarsLeft;
}
