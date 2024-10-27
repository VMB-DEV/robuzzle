import 'package:hive_flutter/adapters.dart';
import '../../constants/hive/hive_adapter_ids.dart';
import '../../constants/hive/progress/hive_fields_progress.dart';
import '../../model/progress/model_functions.dart';
import '../../model/progress/model_progress.dart';

class ProgressAdapter extends TypeAdapter<ProgressModel> {
  @override
  final int typeId = HiveAdapterIds.progress;

  @override
  ProgressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProgressModel(
        id: fields[ProgressHiveFields.id] as int,
        functions: fields[ProgressHiveFields.functions] as FunctionsModel,
        isWin: fields[ProgressHiveFields.win] as bool
    );
  }

  @override
  void write(BinaryWriter writer, ProgressModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(ProgressHiveFields.id)
      ..write(obj.id)
      ..writeByte(ProgressHiveFields.functions)
      ..write(obj.functions)
      ..writeByte(ProgressHiveFields.win)
      ..write(obj.isWin);
  }


}
