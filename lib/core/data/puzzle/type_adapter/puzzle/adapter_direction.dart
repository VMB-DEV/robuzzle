import 'package:hive_flutter/adapters.dart';
import '../../../../../core/data/puzzle/model/model_direction.dart';
import '../../../../../features/level/data/constants/hive/hive_adapter_ids.dart';

class DirectionAdapter extends TypeAdapter<DirectionModel> {
  @override
  final int typeId = HiveAdapterIds.direction;

  @override
  DirectionModel read(BinaryReader reader) {
    switch (reader.readByte()) {
      case DirectionModel.estValue: return DirectionModel.est;
      case DirectionModel.southValue: return DirectionModel.south;
      case DirectionModel.westValue: return DirectionModel.west;
      case DirectionModel.northValue: return DirectionModel.north;
      default: return DirectionModel.est;
    }
  }

  @override
  void write(BinaryWriter writer, DirectionModel obj) {
    switch (obj) {
      case DirectionModel.est: writer.writeByte(DirectionModel.estValue);
      case DirectionModel.south: writer.writeByte(DirectionModel.southValue);
      case DirectionModel.west: writer.writeByte(DirectionModel.westValue);
      case DirectionModel.north: writer.writeByte(DirectionModel.northValue);
    }
  }
}
