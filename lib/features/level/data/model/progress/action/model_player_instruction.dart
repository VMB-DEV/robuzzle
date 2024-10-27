import 'package:hive_flutter/hive_flutter.dart';
import '../../../../domain/entities/progress/action/entity_player_instruction.dart';
import '../../../constants/hive/hive_adapter_ids.dart';
import '../../../constants/hive/progress/action/hive_fields_player_instruction.dart';

@HiveType(typeId: HiveAdapterIds.instruction)
enum PlayerInstructionModel {
  @HiveField(PlayerInstructionHiveFields.function0)
  goToF0(f0Value),
  @HiveField(PlayerInstructionHiveFields.function1)
  goToF1(f1Value),
  @HiveField(PlayerInstructionHiveFields.function2)
  goToF2(f2Value),
  @HiveField(PlayerInstructionHiveFields.function3)
  goToF3(f3Value),
  @HiveField(PlayerInstructionHiveFields.function4)
  goToF4(f4Value),
  @HiveField(PlayerInstructionHiveFields.changeToRed)
  changeColorToRed(changeToRedValue),
  @HiveField(PlayerInstructionHiveFields.changeToBlue)
  changeColorToBlue(changeToBlueValue),
  @HiveField(PlayerInstructionHiveFields.changeToGreen)
  changeColorToGreen(changeToGreenValue),
  @HiveField(PlayerInstructionHiveFields.forward)
  goForward(goForwardValue),
  @HiveField(PlayerInstructionHiveFields.left)
  turnLeft(turnLeftValue),
  @HiveField(PlayerInstructionHiveFields.right)
  turnRight(turnRightValue),
  @HiveField(PlayerInstructionHiveFields.none)
  none(noneValue),
  @HiveField(PlayerInstructionHiveFields.remove)
  remove(removeValue);

  static const f0Value = 0;
  static const f1Value = 1;
  static const f2Value = 2;
  static const f3Value = 3;
  static const f4Value = 4;
  static const changeToRedValue = 5;
  static const changeToBlueValue = 6;
  static const changeToGreenValue = 7;
  static const goForwardValue = 8;
  static const turnLeftValue = 9;
  static const turnRightValue = 10;
  static const noneValue = 11;
  static const removeValue = 12;

  final int value;
  const PlayerInstructionModel(this.value);

  factory PlayerInstructionModel.parseInt({required int value}) => PlayerInstructionModel.values.singleWhere((element) => element.value == value, orElse: () => none);
  factory PlayerInstructionModel.parseString({required String name}) => PlayerInstructionModel.values.singleWhere((element) => element.name == name, orElse: () => none);
  factory PlayerInstructionModel.from({required PlayerInstructionEntity entity}) => PlayerInstructionModel.parseString(name: entity.name);

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
}
