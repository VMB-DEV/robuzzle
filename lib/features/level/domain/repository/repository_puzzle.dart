import '../entities/puzzle/entity_puzzle.dart';

abstract class PuzzleRepository {
  Future<List<PuzzleEntity>> getAllPuzzles();
  Future<List<PuzzleEntity>> getPuzzlesByDifficulty(int difficulty);
  Future<PuzzleEntity> getPuzzleById(int id);
}