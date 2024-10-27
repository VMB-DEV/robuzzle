import 'package:hive/hive.dart';
import '../../../../../core/data/puzzle/model/model_map.dart';
import '../../../../../features/level/data/constants/hive/hive_adapter_ids.dart';

class MapModelAdapter extends TypeAdapter<MapModel> {
  @override
  final int typeId = HiveAdapterIds.map;

  @override
  MapModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MapModel(
      rows: (fields[0] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, MapModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.rows);
  }
}
