import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import '../../../../features/level/data/constants/hive/hive_adapter_ids.dart';

@HiveType(typeId: HiveAdapterIds.map)
class MapModel extends Equatable{
  @HiveField(0)
  final List<String> rows;

  static const int maxRow = 12;
  static const int maxCol = 16;

  const MapModel({required this.rows});

  factory MapModel.parse(String board) {
    List<String> rows = List.generate( maxRow, (int index) => board.substring(index * (maxCol), (index + 1) * maxCol ));
    return MapModel(rows: rows);
  }
  static MapModel emptyMap = MapModel( rows: List.generate(16, (_) => ' ' * 12));

  @override
  List<Object?> get props => [rows];
}