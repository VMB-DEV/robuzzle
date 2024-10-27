import 'package:hive/hive.dart';
import '../../../../features/level/data/constants/hive/hive_adapter_ids.dart';
import '../../../../features/level/data/constants/hive/puzzle/hive_fields_direction.dart';

@HiveType(typeId: HiveAdapterIds.direction)
enum DirectionModel {
  @HiveField(DirectionHiveFields.est)
  est(estValue),
  @HiveField(DirectionHiveFields.south)
  south(southValue),
  @HiveField(DirectionHiveFields.west)
  west(westValue),
  @HiveField(DirectionHiveFields.north)
  north(northValue);

  final int value;
  const DirectionModel(this.value);

  static const int estValue = 0;
  static const int southValue = 1;
  static const int westValue = 2;
  static const int northValue = 3;

  factory DirectionModel.parse(String dataString) {
    int num = int.parse(dataString);
    switch(num) {
      case estValue : return DirectionModel.est;
      case southValue : return DirectionModel.south;
      case westValue : return DirectionModel.west;
      case northValue : return DirectionModel.north;
      default : throw Exception('Unknown value to parse DirectionModel');
    }
  }
}