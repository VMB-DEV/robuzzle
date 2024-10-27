import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/list.dart';
import 'package:robuzzle/core/log/consolColors.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_case_color.dart';
import 'package:robuzzle/features/level/presentation/page/page_level.dart';

import '../puzzle/entity_position.dart';
import 'action/entity_action.dart';
import 'action/entity_player_instruction.dart';

//Todo: STRING hard coded
class FunctionsEntity {
  List<List<ActionEntity>> values;

  FunctionsEntity({required this.values});

  factory FunctionsEntity.emptyFunctions(List<int> functionSizes) {
    return FunctionsEntity(
        values: List.generate(functionSizes.where((size) => size != 0).toList().length,
            (int index) => List.generate(functionSizes[index], (_) => ActionEntity.noAction)));
  }

  FunctionsEntity copyWith(FunctionsEntity functions) => FunctionsEntity(values: functions.values.copy);
  FunctionsEntity get copy => copyWith(this);
  bool get compact => values.length == 5 || (values.length > 3 && _doubleRow >= 3);
  int get _doubleRow => values.where((row) => row.length > rowEndAt).length;

  @override
  String toString() {
    List<String> listFunStr = List.generate(values.length, (row) {
      final String rowStr = List.generate(values[row].length, (col) {
        switch (values[row][col].color) {
          case CaseColorEntity.red:
            return strRed(values[row][col].instruction.toString());
          case CaseColorEntity.blue:
            return strBlue(values[row][col].instruction.toString());
          case CaseColorEntity.green:
            return strGreen(values[row][col].instruction.toString());
          case CaseColorEntity.grey:
            return values[row][col].instruction.toString();
          case CaseColorEntity.none:
            return strYellow(values[row][col].instruction.toString());
        }
      }).join('').replaceAll(' ', '_').replaceAll('F', '');
      return 'F$row: $rowStr';
    });
    return listFunStr.join('\n');
  }

  /// checking if the data store for progress is conform to the puzzle data in term of size
  bool _isConform(List<int> functionSizes) {
    for (var (index, listAction) in values.indexed) {
      if (listAction.length > functionSizes[index]) return false;
    }
    return true;
  }

  /// update the functions extracted form brut data to be used in the Level
  void formatForLevelEntity(List<int> functionSizes) => _isConform(functionSizes) ? _filledFunctions(functionSizes)
      : throw Exception('FunctionsEntity formatForLevelEntity');

  /// Fill the list of Action because ActionEntity.NoAction is not stored in the data to be storage efficient
  void _filledFunctions(List<int> functionSizes) {
    int initLen = values.length;
    int diff = functionSizes.length;
    if (initLen < functionSizes.length) {
      for (int i = initLen; i < diff; ++i) {
        values.add(List.generate(functionSizes[i], (int col) => ActionEntity.noAction));
      }
    }
    for (var (index, size) in functionSizes.indexed) {
      if (values[index].length < size) {
        int diff = size - values[index].length;
        values[index].addAll(List.generate(diff, (int col) => ActionEntity.noAction));
      }
    }
  }

  /// switch two actions in the functions if user want to modify quickly the instructions
  FunctionsEntity switchActions({required PositionEntity action1, required PositionEntity action2}) {
    ActionEntity temp = values[action1.row][action1.col];
    values[action1.row][action1.col] = values[action2.row][action2.col];
    values[action2.row][action2.col] = temp;
    return copyWith(this);
  }

  FunctionsEntity replace({required PositionEntity position, required ActionEntity menuAction}) {
    values[position.row][position.col] = menuAction;
    return copyWith(this);
  }

  /// using an action in the menu to change one in the functions
  FunctionsEntity replaceFromMenu({required PositionEntity position, required ActionEntity menuAction}) {
    final actionTarget = values[position.row][position.col];
    if (menuAction.instruction == PlayerInstructionEntity.none) {
      values[position.row][position.col] = actionTarget.copyWith(color: menuAction.color);
    } else {
      values[position.row][position.col] = actionTarget.copyWith(instruction: menuAction.instruction);
    }
    return copyWith(this);
  }

  /// set a specified action to None
  FunctionsEntity removeAction({required PositionEntity position}) {
    values[position.row][position.col] = ActionEntity.noAction;
    return copyWith(this);
  }
}
