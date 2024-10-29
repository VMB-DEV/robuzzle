import 'package:robuzzle/features/level/domain/entities/progress/action/entity_case_color.dart';

import '../../../../data/model/progress/action/model_player_instruction.dart';

enum PlayerInstructionEntity {
  none,
  goForward,
  turnLeft,
  turnRight,
  goToF0,
  goToF1,
  goToF2,
  goToF3,
  goToF4,
  remove,
  changeColorToRed,
  changeColorToGreen,
  changeColorToBlue;

  factory PlayerInstructionEntity.parseString({required String name}) => PlayerInstructionEntity.values.singleWhere((element) => element.name == name, orElse: () => none);
  factory PlayerInstructionEntity.from({required PlayerInstructionModel model}) => PlayerInstructionEntity.parseString(name: model.name);

  @override
  String toString() {
    switch(this) {
      case goToF0: return '0';
      case goToF1: return '1';
      case goToF2: return '2';
      case goToF3: return '3';
      case goToF4: return '4';
      case changeColorToRed: return 'r';
      case changeColorToGreen: return 'g';
      case changeColorToBlue: return 'b';
      case goForward: return '↑';
      case turnLeft: return '↰';
      case turnRight: return '↱';
      case none: return ' ';
      case remove: return 'x';
      default: return '.';
    }
  }

  static List<PlayerInstructionEntity> functionCalls() => [ goToF0, goToF1, goToF2, goToF3, goToF4];
  static List<PlayerInstructionEntity> playerMoving() => [ turnLeft, goForward, turnRight];
  static List<PlayerInstructionEntity> mapColoring = [ changeColorToRed, changeColorToGreen, changeColorToBlue];
  bool get isFunctionCall => functionCalls().contains(this);
  bool get isPlayerTurning => turnLeft == this || turnRight == this;
  bool get isPlayerMovingForward => goForward == this;
  bool get isChangingMapColor => this == changeColorToBlue || this == changeColorToGreen || this == changeColorToRed;
  bool get isMapColored => mapColoring.contains(this);
  int get functionNumber => switch (this) {
    PlayerInstructionEntity.goToF0 => 0,
    PlayerInstructionEntity.goToF1 => 1,
    PlayerInstructionEntity.goToF2 => 2,
    PlayerInstructionEntity.goToF3 => 3,
    PlayerInstructionEntity.goToF4 => 4,
    _ => throw Exception('PlayerInstructionEntity.functionNumber : $this.name is function call'),
  };
  CaseColorEntity get getColorChange => switch (this) {
    changeColorToRed => CaseColorEntity.red,
    changeColorToGreen => CaseColorEntity.green,
    changeColorToBlue => CaseColorEntity.blue,
    _ => throw Exception('PlayerInstructionEntity.getColorChange : $this.name is not a color'),
  };
}