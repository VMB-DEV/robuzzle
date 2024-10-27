import '../../data/model/progress/model_progress.dart';
import '../entities/progress/entity_progress.dart';

abstract class ProgressRepository {
  Future<ProgressModel> getProgressById(int id);
  void setProgress(ProgressModel progressModel);
  void setWin(int id, int difficulty);
}
