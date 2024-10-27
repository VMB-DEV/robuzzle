import '../repository/repository_progress.dart';

class SetWinUseCase {
  final ProgressRepository progressRepo;

  SetWinUseCase({required this.progressRepo});

  void execute(int id, int difficulty) => progressRepo.setWin(id, difficulty);
}