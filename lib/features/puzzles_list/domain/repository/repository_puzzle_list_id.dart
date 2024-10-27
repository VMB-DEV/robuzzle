abstract class PuzzleListIdRepository {
  Set<int> getIdSetFavPuzzle(int difficulty);
  void setIdSetFavPuzzle(Set<int> set, int difficulty);
  Set<int> getIdSetFinishedPuzzle(int difficulty);
  Future<Set<int>> getIdSetPuzzleByDifficulty(int difficulty);
  void setNewFinishedPuzzle(int levelId, int difficulty);
}