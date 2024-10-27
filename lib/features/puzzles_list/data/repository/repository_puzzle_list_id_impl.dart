import '../../domain/repository/repository_puzzle_list_id.dart';
import '../data_source/local_data_source_puzzle_id_list.dart';

class PuzzleListIdRepositoryImpl extends PuzzleListIdRepository {
  final PuzzleListLocalDataSource localDataSource;

  PuzzleListIdRepositoryImpl({required this.localDataSource});

  @override
  Set<int> getIdSetFinishedPuzzle(int difficulty) {
    return localDataSource.getIdSetFinishedPuzzle(difficulty);
  }

  @override
  Future<Set<int>> getIdSetPuzzleByDifficulty(int difficulty) {
    return localDataSource.getIdSetPuzzleByDifficulty(difficulty);
  }

  @override
  void setNewFinishedPuzzle(int levelId, int difficulty) {
    localDataSource.setNewFinishedPuzzle(levelId, difficulty);
  }

  @override
  Set<int> getIdSetFavPuzzle(int difficulty) {
    return localDataSource.getIdSetFavPuzzleByDifficulty(difficulty);
  }

  @override
  void setIdSetFavPuzzle(Set<int> set, int difficulty) {
    localDataSource.setNewIdSetPuzzlesFavList(set, difficulty);
  }
}
