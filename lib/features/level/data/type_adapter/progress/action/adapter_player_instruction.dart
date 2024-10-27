import 'package:hive_flutter/adapters.dart';
import '../../../constants/hive/hive_adapter_ids.dart';
import '../../../model/progress/action/model_player_instruction.dart';

class PlayerInstructionAdapter extends TypeAdapter<PlayerInstructionModel> {
  @override
  final int typeId = HiveAdapterIds.instruction;

  @override
  PlayerInstructionModel read(BinaryReader reader) => PlayerInstructionModel.parseInt(value: reader.readByte());

  @override
  void write(BinaryWriter writer, PlayerInstructionModel obj) {
    switch (obj) {
      case PlayerInstructionModel.goToF0 : writer.writeByte(PlayerInstructionModel.f0Value);
      case PlayerInstructionModel.goToF1 : writer.writeByte(PlayerInstructionModel.f1Value);
      case PlayerInstructionModel.goToF2 : writer.writeByte(PlayerInstructionModel.f2Value);
      case PlayerInstructionModel.goToF3 : writer.writeByte(PlayerInstructionModel.f3Value);
      case PlayerInstructionModel.goToF4 : writer.writeByte(PlayerInstructionModel.f4Value);
      case PlayerInstructionModel.changeColorToRed : writer.writeByte(PlayerInstructionModel.changeToRedValue);
      case PlayerInstructionModel.changeColorToBlue : writer.writeByte(PlayerInstructionModel.changeToBlueValue);
      case PlayerInstructionModel.changeColorToGreen : writer.writeByte(PlayerInstructionModel.changeToGreenValue);
      case PlayerInstructionModel.goForward : writer.writeByte(PlayerInstructionModel.goForwardValue);
      case PlayerInstructionModel.turnLeft : writer.writeByte(PlayerInstructionModel.turnLeftValue);
      case PlayerInstructionModel.turnRight : writer.writeByte(PlayerInstructionModel.turnRightValue);
      case PlayerInstructionModel.none : writer.writeByte(PlayerInstructionModel.noneValue);
      case PlayerInstructionModel.remove: writer.writeByte(PlayerInstructionModel.removeValue);
    }
  }
}