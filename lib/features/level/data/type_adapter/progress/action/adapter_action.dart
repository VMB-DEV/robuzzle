import 'package:hive_flutter/adapters.dart';
import '../../../constants/hive/hive_adapter_ids.dart';
import '../../../constants/hive/progress/action/hive_fields_action.dart';
import '../../../model/progress/action/model_action.dart';
import '../../../model/progress/action/model_case_color.dart';
import '../../../model/progress/action/model_player_instruction.dart';

class ActionAdapter extends TypeAdapter<ActionModel> {

  @override
  final int typeId = HiveAdapterIds.action;

  @override
  ActionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ActionModel(
      instruction: fields[ActionHiveFields.instruction] as PlayerInstructionModel,
      color: fields[ActionHiveFields.color] as CaseColorModel
    );
  }

  @override
  void write(BinaryWriter writer, ActionModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(ActionHiveFields.color)
      ..write(obj.color)
      ..writeByte(ActionHiveFields.instruction)
      ..write(obj.instruction)
    ;
  }
}