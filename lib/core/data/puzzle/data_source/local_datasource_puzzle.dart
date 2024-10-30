import 'package:hive_flutter/hive_flutter.dart';

import '../model/model_puzzle.dart';

/// Interaction with the dataBase of all PuzzleModel
abstract class PuzzleLocalDataSource {
  Future<List<PuzzleModel>> getAllPuzzleModel();
  Future<Set<PuzzleModel>> getPuzzleModelSetById(Set<int> idList);
  Future<PuzzleModel> getPuzzleModelById(int id);
  Future<void> buildHiveDataBase(Box<PuzzleModel> box);
}