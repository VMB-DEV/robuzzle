import 'dart:math';

import 'package:robuzzle/features/level/domain/entities/puzzle/entity_position.dart';

import '../../../../../core/data/puzzle/model/model_direction.dart';

enum DirectionEntity {
  est,
  south,
  west,
  north;

  factory DirectionEntity.parseString({required String name}) => DirectionEntity.values.singleWhere((element) => element.name == name, orElse: () =>  DirectionEntity.north);
  factory DirectionEntity.from({required DirectionModel model}) => DirectionEntity.parseString(name: model.name);
  static DirectionEntity none() => est;
  DirectionEntity turnLeft() => DirectionEntity.values[(index + 3) & 3];
  DirectionEntity turnRight() => DirectionEntity.values[(index + 1) & 3];
  double get angle => switch (this) {
    DirectionEntity.est => 0.0,
    DirectionEntity.south => 1.57,
    DirectionEntity.west => pi,
    DirectionEntity.north => 4.71,
  };
}
