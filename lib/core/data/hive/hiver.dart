import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:robuzzle/core/data/puzzle/model/model_puzzle.dart';

import '../../../features/level/data/model/progress/model_progress.dart';
import '../../log/consolColors.dart';
import '../puzzle/type_adapter/puzzle/adapter_direction.dart';
import '../puzzle/type_adapter/puzzle/adapter_map.dart';
import '../puzzle/type_adapter/puzzle/adapter_position.dart';
import '../puzzle/type_adapter/puzzle/adapter_puzzle.dart';
import 'hive_box_name.dart';
import '../../../features/level/data/type_adapter/progress/action/adapter_action.dart';
import '../../../features/level/data/type_adapter/progress/action/adapter_case_color.dart';
import '../../../features/level/data/type_adapter/progress/action/adapter_player_instruction.dart';
import '../../../features/level/data/type_adapter/progress/adapter_funcions.dart';
import '../../../features/level/data/type_adapter/progress/adapter_progress.dart';

class Hiver {
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    initAdapters();
    buildPuzzleDataBase();
  }
  
  static void buildPuzzleDataBase() async {
    try {
      await Hive.openBox<PuzzleModel>(HiveBoxName.puzzleBoxName);
      final box = puzzleBox;
      if (box.isEmpty) {
        String puzzlesDataString = await rootBundle.loadString('assets/dataPuzzles/AllPuzzles');
        List<String> listPuzzleStr = puzzlesDataString.split(PuzzleModel.puzzleSeparator);
        List<PuzzleModel> listPuzzles = listPuzzleStr.map((s) => PuzzleModel.parse(s)).toList();
        await Future.forEach(listPuzzles, (PuzzleModel p) async {
          await box.put(p.id, p);
        });
      }
    } catch (e) {
      Log.red('Hiver.buildPuzzleDataBase - failed');
      throw Exception('Hiver.buildPuzzleDataBase - Error\n$e');
    }
  }

  static Box<PuzzleModel> get puzzleBox => Hive.box<PuzzleModel>(HiveBoxName.puzzleBoxName);
  static Future<LazyBox<ProgressModel>> get progressBox => Hive.openLazyBox(HiveBoxName.progressBoxName);

  initAdapters() {
    _initPuzzleAdapters();
    _initProgressionAdapters();
  }

  _initPuzzleAdapters() {
    Hive.registerAdapter(PuzzleAdapter());
    Hive.registerAdapter(PositionAdapter());
    Hive.registerAdapter(MapModelAdapter());
    Hive.registerAdapter(DirectionAdapter());
  }
  _initProgressionAdapters() {
    Hive.registerAdapter(ProgressAdapter());
    Hive.registerAdapter(FunctionsAdapter());
    Hive.registerAdapter(PlayerInstructionAdapter());
    Hive.registerAdapter(CaseColorAdapter());
    Hive.registerAdapter(ActionAdapter());
  }
}