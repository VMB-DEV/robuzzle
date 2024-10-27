import '../repository/repository_puzzle_list_id.dart';

//todo: hard coded string
class GetPuzzleIdListByDiffUseCase {
  PuzzleListIdRepository levelListRepo;
  
  GetPuzzleIdListByDiffUseCase({required this.levelListRepo});

  Future<Set<int>> call(int difficulty) async => 1 <= difficulty && difficulty <= 5
      ? levelListRepo.getIdSetPuzzleByDifficulty(difficulty)
      : throw Exception('PuzzleListByDiffUseCase.call error difficulty has to be between 1 and 5');
}