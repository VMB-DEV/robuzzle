import '../../../../../core/log/consolColors.dart';
import '../../../data/model/progress/model_progress.dart';
import 'action/entity_action.dart';
import 'action/entity_case_color.dart';
import 'action/entity_player_instruction.dart';
import 'entity_functions.dart';

class ProgressEntity {
  int id;
  FunctionsEntity functions;
  bool isWin;

  ProgressEntity({
    required this.id,
    required this.functions,
    required this.isWin,
  });
  factory ProgressEntity.from({required ProgressModel model}) => ProgressEntity(
    id: model.id,
    isWin: model.isWin,
    functions: FunctionsEntity(values: List.generate( model.functions.values.length, (int row)
    => model.functions.values[row].map((actionModel) => ActionEntity.from(actionModel)).toList()
      ,),),
  );

  @override
  String toString() {
    List<String> listFunStr = List.generate(functions.values.length, (row) {
      final String rowStr = List.generate(functions.values[row].length, (col) {
        switch (functions.values[row][col].color) {
          case CaseColorEntity.red:
            return strRed(functions.values[row][col].instruction.toString());
          case CaseColorEntity.blue:
            return strBlue(functions.values[row][col].instruction.toString());
          case CaseColorEntity.green:
            return strGreen(functions.values[row][col].instruction.toString());
          case CaseColorEntity.grey:
            return functions.values[row][col].instruction.toString();
          case CaseColorEntity.none:
            return strYellow(functions.values[row][col].instruction.toString());
        }
      }).join('').replaceAll(' ', '_').replaceAll('F', '');
      return 'F$row: $rowStr';
    });
    return listFunStr.join('\n');
  }
}