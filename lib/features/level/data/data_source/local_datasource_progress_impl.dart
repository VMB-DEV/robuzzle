import 'package:hive_flutter/hive_flutter.dart';
import 'package:robuzzle/core/data/shared_preferences/shared_preferences_keys.dart';
import 'package:robuzzle/core/extensions/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/data/hive/hiver.dart';
import '../model/progress/model_progress.dart';
import 'local_datasource_progress.dart';

class ProgressLocalDataSourceImpl extends ProgressLocalDataSource {
  final SharedPreferences sharedPreferences;
  ProgressLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<ProgressModel> getProgressById(int id) async {
    final Box<ProgressModel> box = await Hiver.progressBox;
    final ProgressModel progress = box.get(id) ?? ProgressModel.empty(id);
    return progress;
  }

  @override
  void setProgress(ProgressModel progress) async {
    final Box<ProgressModel> box = await Hiver.progressBox;
    box.put(progress.id, progress);
  }

  @override
  void setWin(int id, int difficulty) {
    final Set<int> finishedPuzzle = sharedPreferences.getIntSet(SharedPreferencesKeys.puzzleFinished(difficulty)) ?? {};
    finishedPuzzle.add(id);
    sharedPreferences.setIntSet(SharedPreferencesKeys.puzzleFinished(difficulty), finishedPuzzle);
  }
}
