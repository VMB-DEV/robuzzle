import 'package:hive/hive.dart';
import 'package:robuzzle/core/data/puzzle/model/model_position.dart';
import '../../../../features/level/data/constants/hive/hive_adapter_ids.dart';
import '../../../../features/level/data/constants/hive/puzzle/hive_fields_puzzle.dart';
import 'model_direction.dart';
import 'model_map.dart';

@HiveType(typeId: HiveAdapterIds.puzzle)
class PuzzleModel {
  @HiveField(PuzzleHiveFields.id)
  int id;
  @HiveField(PuzzleHiveFields.title)
  String title;
  @HiveField(PuzzleHiveFields.about)
  String about;
  @HiveField(PuzzleHiveFields.author)
  String author;
  @HiveField(PuzzleHiveFields.map)
  MapModel map;
  @HiveField(PuzzleHiveFields.startAt)
  PositionModel startAt;
  @HiveField(PuzzleHiveFields.startDir)
  DirectionModel startDir;
  @HiveField(PuzzleHiveFields.functionSize)
  List<int> functionsSize;
  @HiveField(PuzzleHiveFields.commandAllowed)
  int commandAllowed;

  PuzzleModel({
    required this.id,
    required this.title,
    required this.about,
    required this.author,
    required this.map,
    required this.startAt,
    required this.startDir,
    required this.functionsSize,
    required this.commandAllowed,
  });

  static const String puzzleSeparator = '\n-\n';
  static const String lineSeparator = '\n';
  factory PuzzleModel.parse(String dataString) {
    List<String> listStr = dataString.split(lineSeparator);
    try {
      return PuzzleModel(
        id: int.parse(listStr[0]),
        title: listStr[1],
        about: listStr[2],
        author: listStr[3],
        map: MapModel.parse(listStr[4]),
        startAt: PositionModel.parse(listStr[5]),
        startDir: DirectionModel.parse(listStr[6]),
        functionsSize: listStr[7].split(',').map(int.parse).toList(),
        commandAllowed: int.parse(listStr[8]),
      );
    } catch(e) {
      print('error with level: ${dataString.split(lineSeparator)[0]}');
      rethrow;
    }
  }

  static List<PuzzleModel> puzzleList({required String dataString}) {
    List<String> listPuzzleStr = dataString.split(PuzzleModel.puzzleSeparator);
    return listPuzzleStr.map((s) => PuzzleModel.parse(s)).toList();
  }
}

