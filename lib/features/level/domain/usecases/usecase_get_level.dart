import 'package:robuzzle/features/level/domain/entities/progress/entity_progress.dart';

import '../entities/level/entity_level.dart';
import '../repository/repository_progress.dart';
import '../repository/repository_puzzle.dart';

class GetLevelUseCase {
  final PuzzleRepository puzzleRepo;
  final ProgressRepository progressRepo;

  GetLevelUseCase({required this.puzzleRepo, required this.progressRepo});

  Future<LevelEntity> call(int id) async => LevelEntity.from(
    puzzle: await puzzleRepo.getPuzzleById(id),
    progress: ProgressEntity.from(model: await progressRepo.getProgressById(id))
  );
}
