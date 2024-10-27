import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:robuzzle/core/extensions/sharedPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/data/shared_preferences/shared_preferences_keys.dart';
import '../../../../core/log/consolColors.dart';
import 'local_data_source_puzzle_id_list.dart';

class PuzzleListLocalDataSourceImpl extends PuzzleListLocalDataSource {
  final SharedPreferences sharedPreferences;
  PuzzleListLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Set<int> getIdSetFinishedPuzzle(int difficulty) {
    final Set<int> set = sharedPreferences.getIntSet(SharedPreferencesKeys.puzzleFinished(difficulty)) ?? {};
    return set;
  }

  @override
  void setNewFinishedPuzzle(int levelId, int difficulty) {
    Set<int> set = getIdSetFinishedPuzzle(difficulty);
    set.add(levelId);
    sharedPreferences.setIntSet(SharedPreferencesKeys.puzzleFinished(difficulty), set);
  }

  @override
  Future<Set<int>> getIdSetPuzzleByDifficulty(int difficulty) async {
    Set<int>? set = sharedPreferences.getIntSet(SharedPreferencesKeys.puzzleByDiff(difficulty));
    set ??= await setPuzzleIdByDiff(difficulty);
    return set;
  }

  @override
  Future<Set<int>> setPuzzleIdByDiff(int difficulty) async {
    String levelByDiffStr = await rootBundle.loadString('assets/dataPuzzles/diff$difficulty');
    Set<int> set = levelByDiffStr.split('\n').map((s) => int.parse(s)).toSet();
    sharedPreferences.setIntSet(SharedPreferencesKeys.puzzleByDiff(difficulty), set);
    return set;
  }

  @override
  Set<int> getIdSetFavPuzzleByDifficulty(int difficulty) {
    Set<int> set = sharedPreferences.getIntSet(SharedPreferencesKeys.puzzleFavorite(difficulty)) ?? {};
    return set;
  }

  @override
  void setNewIdSetPuzzlesFavList(Set<int> set, int difficulty) {
    sharedPreferences.setIntSet(SharedPreferencesKeys.puzzleFavorite(difficulty), set);
  }
}
