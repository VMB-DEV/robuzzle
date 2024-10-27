import 'package:robuzzle/core/data/puzzle/model/model_puzzle.dart';

import '../../../../features/puzzles_list/domain/repository/repository_puzzle_list.dart';
import '../data_source/local_datasource_puzzle.dart';

class PuzzleListRepositoryImpl implements PuzzleListRepository {
  final PuzzleLocalDataSource puzzleDataSource;
  PuzzleListRepositoryImpl({required this.puzzleDataSource});

  @override
  Future<Set<PuzzleModel>> getPuzzleModelSetByIds(Set<int> ids) {
    return puzzleDataSource.getPuzzleModelSetById(ids);
  }
}