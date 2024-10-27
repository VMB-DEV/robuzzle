import 'package:hive/hive.dart';
import '../../../../features/level/data/constants/hive/hive_adapter_ids.dart';

@HiveType(typeId: HiveAdapterIds.map)
class MapModel {
  @HiveField(0)
  List<String> rows;

  static const int maxRow = 12;
  static const int maxCol = 16;

  MapModel({required this.rows});

  factory MapModel.parse(String board) {
    List<String> rows = List.generate( maxRow, (int index) => board.substring(index * (maxCol), (index + 1) * maxCol ));
    return MapModel(rows: rows);
  }
  static MapModel emptyMap = MapModel( rows: List.generate(16, (_) => ' ' * 12));
}