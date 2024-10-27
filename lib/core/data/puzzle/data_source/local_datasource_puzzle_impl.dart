import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:robuzzle/core/log/consolColors.dart';
import '../../hive/hiver.dart';
import '../model/model_puzzle.dart';
import 'local_datasource_puzzle.dart';


//TODO: STRING hard coded
class PuzzleLocalDataSourceImpl extends PuzzleLocalDataSource{
  @override
  Future<List<PuzzleModel>> getAllPuzzleModel() async { throw UnimplementedError(); }

  @override
  Future<Set<PuzzleModel>> getPuzzleModelSetById(Set<int> idList) async {
    Log.grey('PuzzleLocalDataSourceImpl.getPuzzleModelSetById - ');
    Box<PuzzleModel> box = Hiver.puzzleBox;
    Set<PuzzleModel> puzzleSet = {};
    for (int id in idList) {
      final PuzzleModel? puzzle = await box.get(id);
      if (puzzle != null) {
        puzzleSet.add(puzzle);
      } else {
        Log.red('PuzzleLocalDataSourceImpl.getPuzzleModelSetById - WARNING: Failed to get puzzle $id from Hive');
      }
    }
    return puzzleSet;
  }

  @override
  Future<PuzzleModel> getPuzzleModelById(int id) async {
    Log.grey('PuzzleLocalDataSourceImpl.getPuzzleModelById - ');
    Box<PuzzleModel> box = Hiver.puzzleBox;
    if (box.isEmpty) { Hiver.buildPuzzleDataBase(); }
    final PuzzleModel? puzzle = box.get(id);
    if (puzzle != null) {
      return puzzle;
    } else {
      Log.red('PuzzleLocalDataSourceImpl.getPuzzleModelById - Failed to get puzzle $id form hive');
      throw Exception('PuzzleLocalDataSourceImpl.getPuzzleModelById ERROR : Failed to get puzzle $id form hive');
    }
  }

  @override
  Future<void> buildHiveDataBase(Box<PuzzleModel> box) async {
    Log.red('PuzzleLocalDataSourceImpl.buildHiveDataBase - ');
    String contentStr = await rootBundle.loadString('assets/dataPuzzles/AllPuzzles');
    List<String> listPuzzleStr = contentStr.split(PuzzleModel.puzzleSeparator);
    List<PuzzleModel> listPuzzles = listPuzzleStr.map((s) => PuzzleModel.parse(s)).toList();
    for (var p in listPuzzles) { box.put(p.id, p); }
  }
}