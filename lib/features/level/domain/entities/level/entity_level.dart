import 'package:robuzzle/core/extensions/set.dart';
import 'package:robuzzle/core/log/method_name.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_action_menu.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_action.dart';
import '../../../../../core/log/consolColors.dart';
import '../progress/entity_functions.dart';
import '../progress/entity_progress.dart';
import '../puzzle/entity_direction.dart';
import '../puzzle/entity_map.dart';
import '../puzzle/entity_position.dart';
import '../puzzle/entity_puzzle.dart';

//Todo: STRING hard coded
class LevelEntity {
  final int id;
  final String title;
  final String about;
  final String author;
  final MapEntity map;
  final int commandAllowed;
  FunctionsEntity functions;

  bool isWin;
  ActionMenuEntity menu;

  LevelEntity({
    required this.id,
    required this.title,
    required this.about,
    required this.author,
    required this.map,
    required this.commandAllowed,
    required this.functions,
    required this.isWin,
    required this.menu,
  });

  factory LevelEntity.from({ required PuzzleEntity puzzle, required ProgressEntity progress }) {
    Log.grey('LevelEntity.from - ');
    if (puzzle.id != progress.id) { throw Exception('Error creating LevelEntity, puzzle.id = ${puzzle.id} and progress.id = ${progress.id}'); }
    Log.white('LevelEntity.from - p ${progress.toString()}');
    final functions = progress.functions..formatForLevelEntity(puzzle.functionsSizes);
    Log.white('LevelEntity.from - p ${progress.toString()}');
    final map = puzzle.map.copy..cleanRows();

    final menu = ActionMenuEntity.from( allowedCommand:  puzzle.commandAllowed, map: puzzle.map, functions: progress.functions, );
    final level = LevelEntity(
      id: puzzle.id,
      title: puzzle.title,
      about: puzzle.about,
      author: puzzle.author,
      map: map,
      commandAllowed: puzzle.commandAllowed,
      menu: menu,
      functions: functions,
      isWin: progress.isWin,
    );

    // level.printIt();
    // print('LevelEntity.from - ');
    // print(level);

    return level;
  }

  @override
  String toString() {
    return "id: $id\n"
        'title : $title\n'
        'commands $commandAllowed\n'
        'start : ${map.ship.dir.name} ${map.ship.pos.toString()}\n'
        'map : \n${map.toString()}\n'
        '${functions.toString()}\n'
      // 'stars: ${map.star}'
        // 'stars : ${List.generate(map.stars.length, (i) => map.stars[i].toString()).join(' ')}'
      ;
  }

  //TODO: print
  void printIt() {
    print(callerMethodNameFrom(StackTrace.current));
    print(toString());
  }

  LevelEntity copyWith({
    int? id,
    String? title,
    String? about,
    String? author,
    MapEntity? map,
    PositionEntity? startAt,
    DirectionEntity? startDir,
    int? commandAllowed,
    FunctionsEntity? functions,
    List<PositionEntity>? starsPositions,
    bool? isWin,
    ActionMenuEntity? menu,
  }) {
    return LevelEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      about: about ?? this.about,
      author: author ?? this.author,
      map: map ?? this.map,
      commandAllowed: commandAllowed ?? this.commandAllowed,
      functions: functions ?? this.functions,
      isWin: isWin ?? this.isWin,
      menu: menu ?? this.menu,
    );
  }
  LevelEntity get copy => copyWith();

}