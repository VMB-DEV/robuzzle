import '../repository/repository_puzzle_list_id.dart';

class GetPuzzleIdListFavByDiffUseCase {
  PuzzleListIdRepository levelListRepo;

  GetPuzzleIdListFavByDiffUseCase({required this.levelListRepo});

  Future<Set<int>> call(int difficulty) async => 1 <= difficulty && difficulty <= 5
      ? levelListRepo.getIdSetFavPuzzle(difficulty)
      : throw Exception('GetPuzzleIdListFavByDiffUseCase.call error difficulty has to be between 1 and 5');
}
