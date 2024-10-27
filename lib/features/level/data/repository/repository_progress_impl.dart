import '../../../../core/log/consolColors.dart';
import '../../domain/entities/progress/entity_progress.dart';
import '../../domain/repository/repository_progress.dart';
import '../data_source/local_datasource_progress.dart';
import '../model/progress/model_progress.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressLocalDataSource progressDataSource;

  ProgressRepositoryImpl({required this.progressDataSource});

  @override
  Future<ProgressModel> getProgressById(int id) async {
    ProgressModel progressModel = await progressDataSource.getProgressById(id);
    return progressModel;
  }

  @override
  void setProgress(ProgressModel progressModel) {
    progressDataSource.setProgress(progressModel);
  }

  @override
  void setWin(int id, int difficulty) {
    progressDataSource.setWin(id, difficulty);
  }
}