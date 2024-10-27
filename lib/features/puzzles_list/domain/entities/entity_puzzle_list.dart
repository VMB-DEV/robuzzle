import 'package:equatable/equatable.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_puzzle.dart';

class PuzzleListEntity extends Equatable {
  final PuzzleEntity puzzle;
  final bool finished;

  const PuzzleListEntity({ required this.puzzle, required this.finished });
  PuzzleListEntity get copy => PuzzleListEntity(puzzle: puzzle.copy, finished: finished);

  static PuzzleListEntity get empty => PuzzleListEntity(puzzle: PuzzleEntity.empty, finished: false);

  @override
  bool operator ==(Object other) => other is PuzzleListEntity && other.puzzle.id == puzzle.id;

  @override
  List<Object?> get props => [puzzle, finished];


  @override
  int get hashCode => puzzle.id.hashCode;
}