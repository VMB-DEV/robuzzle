import '../../../../core/data/puzzle/model/model_puzzle.dart';

abstract class PuzzleListRepository {
  Future<Set<PuzzleModel>> getPuzzleModelSetByIds(Set<int> ids);
}