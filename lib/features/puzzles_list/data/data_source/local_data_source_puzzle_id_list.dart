abstract class PuzzleListLocalDataSource {
  Set<int> getIdSetFinishedPuzzle(int difficulty);
  Future<Set<int>> getIdSetPuzzleByDifficulty(int difficulty);
  Set<int> getIdSetFavPuzzleByDifficulty(int difficulty);
  void setNewFinishedPuzzle(int levelId, int difficulty);
  void setNewIdSetPuzzlesFavList(Set<int> set, int difficulty);
  Future<Set<int>> setPuzzleIdByDiff(int difficulty);
}