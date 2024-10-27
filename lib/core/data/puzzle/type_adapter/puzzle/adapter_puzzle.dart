import 'package:hive/hive.dart';
import '../../../../../core/data/puzzle/model/model_position.dart';
import '../../../../../core/data/puzzle/model/model_puzzle.dart';
import '../../../../../core/data/puzzle/model/model_direction.dart';
import '../../../../../core/data/puzzle/model/model_map.dart';
import '../../../../../features/level/data/constants/hive/hive_adapter_ids.dart';
import '../../../../../features/level/data/constants/hive/puzzle/hive_fields_puzzle.dart';

class PuzzleAdapter extends TypeAdapter<PuzzleModel> {
  @override
  final int typeId = HiveAdapterIds.puzzle;

  @override
  PuzzleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PuzzleModel(
      id: fields[PuzzleHiveFields.id] as int,
      title: fields[PuzzleHiveFields.title] as String,
      about: fields[PuzzleHiveFields.about] as String,
      author: fields[PuzzleHiveFields.author] as String,
      map: fields[PuzzleHiveFields.map] as MapModel,
      startAt: fields[PuzzleHiveFields.startAt] as PositionModel,
      startDir: fields[PuzzleHiveFields.startDir] as DirectionModel,
      functionsSize: (fields[PuzzleHiveFields.functionSize] as List).cast<int>(),
      commandAllowed: fields[PuzzleHiveFields.commandAllowed] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, PuzzleModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(PuzzleHiveFields.id)
      ..write(obj.id)
      ..writeByte(PuzzleHiveFields.title)
      ..write(obj.title)
      ..writeByte(PuzzleHiveFields.about)
      ..write(obj.about)
      ..writeByte(PuzzleHiveFields.author)
      ..write(obj.author)
      ..writeByte(PuzzleHiveFields.map)
      ..write(obj.map)
      ..writeByte(PuzzleHiveFields.startAt)
      ..write(obj.startAt)
      ..writeByte(PuzzleHiveFields.startDir)
      ..write(obj.startDir)
      ..writeByte(PuzzleHiveFields.functionSize)
      ..write(obj.functionsSize)
      ..writeByte(PuzzleHiveFields.commandAllowed)
      ..write(obj.commandAllowed);
  }
}