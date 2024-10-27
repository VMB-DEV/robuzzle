import 'package:hive_flutter/hive_flutter.dart';
import '../../../../domain/entities/progress/action/entity_case_color.dart';
import '../../../constants/hive/hive_adapter_ids.dart';
import '../../../constants/hive/progress/action/hive_fields_case_color.dart';

@HiveType(typeId: HiveAdapterIds.color)
enum CaseColorModel {
  @HiveField(CaseColorHiveFields.red)
  red(redValue),
  @HiveField(CaseColorHiveFields.blue)
  blue(blueValue),
  @HiveField(CaseColorHiveFields.green)
  green(greenValue),
  @HiveField(CaseColorHiveFields.gray)
  grey(grayValue),
  @HiveField(CaseColorHiveFields.none)
  none(noneValue);

  
  static const int redValue = 0;
  static const int blueValue = 1;
  static const int greenValue = 2;
  static const int grayValue = 3;
  static const int noneValue = 4;
  
  final int value;
  const CaseColorModel(this.value);

  factory CaseColorModel.parseInt({required int value}) => CaseColorModel.values.singleWhere((element) => element.value == value, orElse: () => none);
  factory CaseColorModel.parseString({required String name}) => CaseColorModel.values.singleWhere((element) => element.name == name, orElse: () => none);
  factory CaseColorModel.from({required CaseColorEntity entity}) => CaseColorModel.parseString(name: entity.name);
}
