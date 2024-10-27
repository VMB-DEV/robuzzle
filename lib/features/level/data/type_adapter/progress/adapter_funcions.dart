import 'package:hive_flutter/adapters.dart';
import '../../constants/hive/hive_adapter_ids.dart';
import '../../constants/hive/progress/hive_fields_functions.dart';
import '../../model/progress/action/model_action.dart';
import '../../model/progress/model_functions.dart';

class FunctionsAdapter extends TypeAdapter<FunctionsModel> {
  @override
  final int typeId = HiveAdapterIds.functions;

  @override
  FunctionsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return FunctionsModel(
      values: (fields[FunctionsHiveFields.values] as List)
          .map((e) => (e as List).cast<ActionModel>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, FunctionsModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(FunctionsHiveFields.values)
      ..write(obj.values);
  }
}
