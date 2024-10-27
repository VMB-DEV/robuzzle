import '../model/progress/model_progress.dart';

abstract class ProgressLocalDataSource {
  Future<ProgressModel> getProgressById(int id);
  void setProgress(ProgressModel progress);
  void setWin(int id, int difficulty);
}
