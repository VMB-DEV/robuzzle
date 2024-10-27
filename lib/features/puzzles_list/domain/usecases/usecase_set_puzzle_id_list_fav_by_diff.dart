import '../repository/repository_puzzle_list_id.dart';

class SetPuzzleIdListFavByDiffUseCase {
  PuzzleListIdRepository levelListRepo;

  SetPuzzleIdListFavByDiffUseCase({required this.levelListRepo});

  void call(Set<int> set, int difficulty) async => 1 <= difficulty && difficulty <= 5
      ? levelListRepo.setIdSetFavPuzzle(set, difficulty)
      : throw Exception('GetPuzzleIdListFavByDiffUseCase.call error difficulty has to be between 1 and 5');
}
