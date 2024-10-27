import 'package:equatable/equatable.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_direction.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_position.dart';

class ShipEntity extends Equatable {
  final PositionEntity pos;
  final DirectionEntity dir;

  ShipEntity({required this.pos, required this.dir});
  ShipEntity get copy => copyWith();
  ShipEntity copyWith({PositionEntity? pos, DirectionEntity? dir})
  // => ShipEntity(pos: pos ?? this.pos.copy, dir: dir ?? this.dir);
  => ShipEntity(
    pos: pos?.copy ?? this.pos.copy,
    dir: dir ?? this.dir,
  );
  factory ShipEntity.none() => ShipEntity(pos: PositionEntity.none(), dir: DirectionEntity.none());
  // ShipEntity moveForward() => copyWith(pos: pos.getNextPosition(dir));

  ShipEntity get turnedLeft => copyWith(dir: dir.turnLeft());
  ShipEntity get turnedRight => copyWith(dir: dir.turnRight());
  ShipEntity get movedForward => copyWith(pos: pos.getNextPosition(dir));
  ShipEntity movePosition({int rowOffset = 0, int colOffset = 0})
  => copyWith(pos: PositionEntity(row: pos.row + rowOffset, col: pos.col + colOffset));
  // ShipEntity get remove => copyWith(pos: pos.getNextPosition(dir));
  // ShipEntity copy() = ShipEntity
  // factory ShipEntity.copy) => ShipEntity(pos: PositionEntity.none(), dir: DirectionEntity.none());
// static ShipEntity copy = ShipEntity()
  @override
  String toString() {
    return '${dir.name.padRight(5, ' ')} $pos';
  }

  @override
  List<Object?> get props => [ pos, dir, ];
}