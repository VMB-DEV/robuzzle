import 'package:robuzzle/features/level/data/model/progress/model_progress.dart';
import 'package:robuzzle/features/level/domain/entities/progress/entity_progress.dart';

import '../repository/repository_progress.dart';

class SetProgressUseCase {
  final ProgressRepository progressRepo;

  SetProgressUseCase({required this.progressRepo});
  
  void execute(ProgressEntity progress) => progressRepo.setProgress(ProgressModel.from(progress));
}