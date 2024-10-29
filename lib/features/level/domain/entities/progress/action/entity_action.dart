import 'package:equatable/equatable.dart';
import 'package:robuzzle/core/log/consolColors.dart';
import 'package:robuzzle/features/level/data/model/progress/action/model_action.dart';

import 'entity_case_color.dart';
import 'entity_player_instruction.dart';

class ActionEntity extends Equatable{
  final PlayerInstructionEntity instruction;
  final CaseColorEntity color;

  const ActionEntity({required this.instruction, required this.color});
  factory ActionEntity.from(ActionModel model) => ActionEntity(
    instruction: PlayerInstructionEntity.from(model: model.instruction),
    color: CaseColorEntity.from(model: model.color),
  );

  ActionEntity copyWith({
    PlayerInstructionEntity? instruction,
    CaseColorEntity? color,
  }) => ActionEntity(
    instruction: instruction ?? this.instruction,
    color: color ?? this.color,
  );
  ActionEntity get copy => copyWith();

  @override
  List<Object?> get props => [instruction, color];

  @override
  String toString() {
    switch (color) {
      case CaseColorEntity.red: return strRed(instruction.toString());
      case CaseColorEntity.blue: return strBlue(instruction.toString());
      case CaseColorEntity.green: return strGreen(instruction.toString());
      case CaseColorEntity.grey: return instruction.toString();
      case CaseColorEntity.none: return '-';
    }
  }

  static ActionEntity noAction = const ActionEntity(instruction: PlayerInstructionEntity.none, color: CaseColorEntity.neutral);
  static ActionEntity remove = const ActionEntity(instruction: PlayerInstructionEntity.remove, color: CaseColorEntity.neutral);
  static ActionEntity firstAction = const ActionEntity(instruction: PlayerInstructionEntity.goToF0, color: CaseColorEntity.neutral);

  /// function designed to check if a action in the menu could merge with a color
  bool get canMergeWithColor =>  (color == CaseColorEntity.neutral);
  bool canMergeWith(ActionEntity action) => ((isNoneInstruction && !action.isNoneInstruction) || (!isNoneInstruction && action.isNoneInstruction)) ;
  bool get isNeutralColor => color == CaseColorEntity.neutral;
  bool get isNoneInstruction => instruction == PlayerInstructionEntity.none;
  bool get isChangeColor => instruction.isChangingMapColor;
  bool get isAction => this != noAction;
  bool get isRemoveInstruction => instruction == PlayerInstructionEntity.remove;
  ActionEntity mergeWith(ActionEntity action) => ActionEntity(
    instruction: isNoneInstruction ? action.instruction : instruction,
    color: isNoneInstruction ? color : action.color,
  );
}