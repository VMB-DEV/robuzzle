import '../../../../features/level/domain/entities/puzzle/entity_puzzle.dart';
import '../../../../features/level/domain/repository/repository_puzzle.dart';
import '../data_source/local_datasource_puzzle.dart';
import '../model/model_puzzle.dart';

class PuzzleRepositoryImpl implements PuzzleRepository {
  final PuzzleLocalDataSource puzzleDataSource;

  PuzzleRepositoryImpl({required this.puzzleDataSource});

  @override
  Future<List<PuzzleEntity>> getAllPuzzles() async {
    List<PuzzleModel> list = await puzzleDataSource.getAllPuzzleModel();
    return list
        .map((puzzleModel) => PuzzleEntity.fromModel(puzzleModel))
        .toList();
  }

  @override
  Future<PuzzleEntity> getPuzzleById(int id) async {
    PuzzleModel puzzleModel = await puzzleDataSource.getPuzzleModelById(id);
    return PuzzleEntity.fromModel(puzzleModel);
  }

  @override
  Future<List<PuzzleEntity>> getPuzzlesByDifficulty(int difficulty) async {
    // TODO: implement getPuzzleByDiff
    throw UnimplementedError();
  }

}