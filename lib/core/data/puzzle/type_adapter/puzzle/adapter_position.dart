import 'package:hive/hive.dart';
import '../../../../../core/data/puzzle/model/model_position.dart';
import '../../../../../features/level/data/constants/hive/hive_adapter_ids.dart';
import '../../../../../features/level/data/constants/hive/puzzle/hive_fields_position.dart';

class PositionAdapter extends TypeAdapter<PositionModel> {
  @override
  final int typeId = HiveAdapterIds.position;

  @override
  PositionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PositionModel(
      row: fields[PositionHiveFields.row] as int,
      col: fields[PositionHiveFields.col] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PositionModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(PositionHiveFields.row)
      ..write(obj.row)
      ..writeByte(PositionHiveFields.col)
      ..write(obj.col);
  }
}