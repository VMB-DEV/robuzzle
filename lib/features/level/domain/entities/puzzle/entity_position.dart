import 'package:equatable/equatable.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_direction.dart';

import '../../../../../core/data/puzzle/model/model_position.dart';

class PositionEntity extends Equatable{
  final int row;
  final int col;

  const PositionEntity({required this.row, required this.col});
  factory PositionEntity.from({required PositionModel model}) {
    return PositionEntity(row: model.row, col: model.col);
  }
  PositionEntity copyWith({int? row, int? col}) => PositionEntity(row: row ?? this.row, col: col ?? this.col);
  PositionEntity get copy => copyWith();

  static PositionEntity none() => const PositionEntity(row: -21, col: -21);
  // static PositionEntity firstPosition() => PositionEntity(row: 0, col: 0);

  @override
  List<Object?> get props => [row, col];

  @override
  String toString() {
    return '($row, $col)';
  }

  PositionEntity getNextPosition(DirectionEntity direction) {
    switch(direction) {
      case DirectionEntity.est: return copyWith(col: col + 1);
      case DirectionEntity.south: return copyWith(row: row + 1);
      case DirectionEntity.west: return copyWith(col: col - 1);
      case DirectionEntity.north: return copyWith(row: row - 1);
    }
  }

}
