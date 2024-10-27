import 'package:equatable/equatable.dart';
import 'package:robuzzle/core/extensions/list.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_ship.dart';

import '../../../../../core/data/puzzle/model/model_puzzle.dart';
import 'entity_direction.dart';
import 'entity_map.dart';
import 'entity_position.dart';

class PuzzleEntity extends Equatable {
  final int id;
  final String title;
  final String about;
  final String author;
  final MapEntity map;
  final List<int> functionsSizes;
  final int commandAllowed;

  const PuzzleEntity({
    required this.id,
    required this.title,
    required this.about,
    required this.author,
    required this.map,
    required this.functionsSizes,
    required this.commandAllowed,
  });

  factory PuzzleEntity.fromModel(PuzzleModel puzzleModel) {
    return PuzzleEntity(
      id: puzzleModel.id,
      title: puzzleModel.title,
      about: puzzleModel.about.isEmpty ? '" "' : puzzleModel.about,
      author: puzzleModel.author,
      map: MapEntity.from(
        model: puzzleModel.map,
        position: PositionEntity.from(model: puzzleModel.startAt),
        direction: DirectionEntity.from(model: puzzleModel.startDir),
      ),
      functionsSizes: puzzleModel.functionsSize.noZero(),
      commandAllowed: puzzleModel.commandAllowed,
    );
  }

  PuzzleEntity get copy => PuzzleEntity(
    id: id,
    title: title,
    about: about,
    author: author,
    map: map.copy,
    functionsSizes: functionsSizes.copy,
    commandAllowed: commandAllowed,
  );

  static PuzzleEntity get empty => PuzzleEntity(
    id: -42,
    title: "",
    about: "",
    author: "",
    map: MapEntity.empty,
    functionsSizes: const [],
    commandAllowed: 0,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    about,
    author,
    map,
    functionsSizes,
    commandAllowed,
  ];
}