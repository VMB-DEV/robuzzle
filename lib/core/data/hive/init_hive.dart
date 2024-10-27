import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:robuzzle/features/level/data/type_adapter/progress/action/adapter_action.dart';
import 'package:robuzzle/features/level/data/type_adapter/progress/action/adapter_case_color.dart';
import 'package:robuzzle/features/level/data/type_adapter/progress/action/adapter_player_instruction.dart';
import 'package:robuzzle/features/level/data/type_adapter/progress/adapter_funcions.dart';
import 'package:robuzzle/features/level/data/type_adapter/progress/adapter_progress.dart';

import '../puzzle/type_adapter/puzzle/adapter_direction.dart';
import '../puzzle/type_adapter/puzzle/adapter_map.dart';
import '../puzzle/type_adapter/puzzle/adapter_position.dart';
import '../puzzle/type_adapter/puzzle/adapter_puzzle.dart';

Future<void> initHive() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  /// registering Puzzle related adapters
  Hive.registerAdapter(PuzzleAdapter());
  Hive.registerAdapter(PositionAdapter());
  Hive.registerAdapter(MapModelAdapter());
  Hive.registerAdapter(DirectionAdapter());

  /// registering Progression related adapters
  Hive.registerAdapter(ProgressAdapter());
  Hive.registerAdapter(FunctionsAdapter());
  Hive.registerAdapter(PlayerInstructionAdapter());
  Hive.registerAdapter(CaseColorAdapter());
  Hive.registerAdapter(ActionAdapter());


}
