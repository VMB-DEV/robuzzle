import 'package:hive_flutter/hive_flutter.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_action.dart';
import '../../../constants/hive/hive_adapter_ids.dart';
import '../../../constants/hive/progress/action/hive_fields_action.dart';
import 'model_case_color.dart';
import 'model_player_instruction.dart';

@HiveType(typeId: HiveAdapterIds.action)
class ActionModel {
  @HiveField(ActionHiveFields.instruction)
  PlayerInstructionModel instruction;

  @HiveField(ActionHiveFields.color)
  CaseColorModel color;

  ActionModel({required this.instruction, required this.color});
  factory ActionModel.from(ActionEntity entity) => ActionModel(
    instruction: PlayerInstructionModel.from(entity: entity.instruction),
    color: CaseColorModel.from(entity: entity.color),
  );
}
