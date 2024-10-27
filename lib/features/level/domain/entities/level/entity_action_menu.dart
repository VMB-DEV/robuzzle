import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:robuzzle/core/extensions/map.dart';
import 'package:robuzzle/core/extensions/string.dart';
import 'package:robuzzle/core/log/consolColors.dart';
import 'package:robuzzle/core/log/method_name.dart';
import 'package:robuzzle/features/level/domain/entities/progress/entity_functions.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_map.dart';

import '../progress/action/entity_action.dart';
import '../progress/action/entity_case_color.dart';
import '../progress/action/entity_player_instruction.dart';

class ActionMenuEntity {
  List<List<ActionEntity>> rows;
  ActionMenuEntity({required this.rows});

  factory ActionMenuEntity.from({ required int allowedCommand, required MapEntity map, required FunctionsEntity functions })
  => ActionMenuEntity(rows: _getMenu(allowedCommand, map, functions));
  // rows = _getMenu(allowedCommand, map, functions);

  static ActionMenuEntity empty = ActionMenuEntity(rows: []);

  /// returning a menu of actions the player can use to complete the level
  static List<List<ActionEntity>> _getMenu(int allowedCommand, MapEntity map, FunctionsEntity functions) {
    final List<CaseColorEntity> colorsPresent = _getMapColors(map);
    // colorsPresent.forEach((e) => printYellow(e.name));
    final List<PlayerInstructionEntity> functionsInstructions = _getInstructionsAllowedForFunctions(functions);
    final List<PlayerInstructionEntity> mapInstructions = _getInstructionsAllowedForMap(allowedCommand);
    return _getActionsMenu(colorsPresent, functionsInstructions, mapInstructions);
  }

  /// generate a menu of actions base on the available colors and instructions
  static List<List<ActionEntity>> _getActionsMenu(
      List<CaseColorEntity> colors,
      List<PlayerInstructionEntity> functionsInstructions,
      List<PlayerInstructionEntity> mapInstructions
  ) => [
    List.generate(
        colors.length,
            (index) => ActionEntity(instruction: PlayerInstructionEntity.none, color: colors[index])
    ),
    List.generate(
        functionsInstructions.length,
            (index) => ActionEntity(instruction: functionsInstructions[index], color: CaseColorEntity.grey)
    ),
    List.generate(
        PlayerInstructionEntity.playerMoving().length,
            (index) => ActionEntity(instruction: PlayerInstructionEntity.playerMoving()[index], color: CaseColorEntity.grey)
    ),
    [
      ...List.generate(
            mapInstructions.length,
                (index) => ActionEntity(instruction: mapInstructions[index], color: CaseColorEntity.grey)
        ),
      ActionEntity(instruction: PlayerInstructionEntity.remove, color: CaseColorEntity.grey),
    ]

  ];

  /// return the necessary instructions for user to call function of actions
  static List<PlayerInstructionEntity> _getInstructionsAllowedForFunctions(FunctionsEntity functions) {
     return [
      PlayerInstructionEntity.goToF0,
      PlayerInstructionEntity.goToF1,
      PlayerInstructionEntity.goToF2,
      PlayerInstructionEntity.goToF3,
      PlayerInstructionEntity.goToF4,
    ].sublist(0, functions.values
        .where((list) => list.isNotEmpty)
        .length);
  }

  /// return the allowed actions giving the player right to change map cases color
  static List<PlayerInstructionEntity> _getInstructionsAllowedForMap(int allowedCommand) {
    return [
      PlayerInstructionEntity.changeColorToRed,
      PlayerInstructionEntity.changeColorToGreen,
      PlayerInstructionEntity.changeColorToBlue,
    ]
        .reversed
        .mapIndexed((index, i) => allowedCommand.toRadixString(2).padLeft(3, '0')[index] == '1' ? i : null)
        .nonNulls
        .toList();
  }

  /// returning the colors used in the map
  static List<CaseColorEntity> _getMapColors(MapEntity map) {
    Set rowsStr = map.rows.join().characters.toSet();
    return CaseColorEntity.values
        .map((color) => color.toString())
        .where((letter) => (rowsStr.contains(letter) || rowsStr.contains(letter.lowerOrUpper)))
        .map(CaseColorEntity.fromString)
        .toSet()
        .toList()
      ..add(CaseColorEntity.grey);
  }
}