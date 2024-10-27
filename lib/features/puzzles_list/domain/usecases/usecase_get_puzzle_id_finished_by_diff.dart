import '../repository/repository_puzzle_list_id.dart';

//todo: hard coded string
class GetPuzzleIdListFinishedByDiffUseCase {
  PuzzleListIdRepository levelListRepo;

  GetPuzzleIdListFinishedByDiffUseCase({required this.levelListRepo});

  Future<Set<int>> call(int difficulty) async => 1 <= difficulty && difficulty <= 5
      ? levelListRepo.getIdSetFinishedPuzzle(difficulty)
      : throw Exception('GetPuzzleIdListFinishedByDiffUseCase.call error difficulty has to be between 1 and 5');
}