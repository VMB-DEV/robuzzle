import 'package:hive_flutter/hive_flutter.dart';
import 'package:robuzzle/features/level/domain/entities/progress/entity_functions.dart';
import '../../constants/hive/hive_adapter_ids.dart';
import '../../constants/hive/progress/hive_fields_functions.dart';
import 'action/model_action.dart';

@HiveType(typeId: HiveAdapterIds.functions)
class FunctionsModel {
  @HiveField(FunctionsHiveFields.values)
  List<List<ActionModel>> values;

  FunctionsModel({required this.values});
  factory FunctionsModel.from(FunctionsEntity entity) => FunctionsModel(
    values: List.generate(entity.values.length, (i) => entity.values[i].map((actionEntity) => ActionModel.from(actionEntity)).toList(),)
  );
}
