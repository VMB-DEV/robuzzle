import 'package:hive_flutter/hive_flutter.dart';
import 'package:robuzzle/features/level/data/model/progress/model_functions.dart';
import 'package:robuzzle/features/level/domain/entities/progress/entity_progress.dart';
import '../../../../../core/log/consolColors.dart';
import '../../constants/hive/hive_adapter_ids.dart';
import '../../constants/hive/progress/hive_fields_progress.dart';
import 'action/model_case_color.dart';

@HiveType(typeId: HiveAdapterIds.progress)
class ProgressModel {
  @HiveField(ProgressHiveFields.id)
  int id;
  @HiveField(ProgressHiveFields.functions)
  FunctionsModel functions;
  @HiveField(ProgressHiveFields.win)
  bool isWin;

  ProgressModel({
    required this.id,
    required this.functions,
    required this.isWin,
  });

  factory ProgressModel.empty(int id) => ProgressModel(
      id: id,
      functions: FunctionsModel(values: []),
      isWin: false
  );

  factory ProgressModel.from(ProgressEntity entity) => ProgressModel(
    id: entity.id,
    functions: FunctionsModel.from(entity.functions),
    isWin: entity.isWin,
  );

  @override
  String toString() {
    List<String> listFunStr = List.generate(functions.values.length, (row) {
      final String rowStr = List.generate(functions.values[row].length, (col) {
        switch (functions.values[row][col].color) {
          case CaseColorModel.red:
            return strRed(functions.values[row][col].instruction.toString());
          case CaseColorModel.blue:
            return strBlue(functions.values[row][col].instruction.toString());
          case CaseColorModel.green:
            return strGreen(functions.values[row][col].instruction.toString());
          case CaseColorModel.grey:
            return functions.values[row][col].instruction.toString();
          case CaseColorModel.none:
            return strYellow(functions.values[row][col].instruction.toString());
        }
      }).join('').replaceAll(' ', '_').replaceAll('F', '');
      return 'F$row: $rowStr';
    });
    return listFunStr.join('\n');
  }
}
