import 'package:hive/hive.dart';
import '../../../../features/level/data/constants/hive/hive_adapter_ids.dart';
import '../../../../features/level/data/constants/hive/puzzle/hive_fields_position.dart';

@HiveType(typeId: HiveAdapterIds.position)
class PositionModel {
  @HiveField(PositionHiveFields.row)
  int row;
  @HiveField(PositionHiveFields.col)
  int col;

  PositionModel({required this.row, required this.col});

  factory PositionModel.parse(String dataString) {
    var [row, col] = dataString.split(',').map(int.parse).toList();
    return PositionModel(row: row, col: col);
  }
}