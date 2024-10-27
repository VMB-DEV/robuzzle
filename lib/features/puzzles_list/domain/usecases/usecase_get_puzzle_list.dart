import 'package:robuzzle/features/level/domain/entities/puzzle/entity_puzzle.dart';

import '../repository/repository_puzzle_list.dart';

class GetPuzzleEntityListById {
  PuzzleListRepository puzzleRepo;
  GetPuzzleEntityListById({required this.puzzleRepo});
  
  Future<Set<PuzzleEntity>> execute(ids) async {
    final modelSet = await puzzleRepo.getPuzzleModelSetByIds(ids);
    return modelSet.map((model) => PuzzleEntity.fromModel(model)).toSet();
  }
}