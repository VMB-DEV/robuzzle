import 'package:equatable/equatable.dart';
import 'package:robuzzle/core/extensions/list.dart';
import 'package:robuzzle/core/extensions/set.dart';
import 'package:robuzzle/core/extensions/string.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_ship.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_action.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_case_color.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_direction.dart';

import '../../../../../core/log/consolColors.dart';
import '../../../../../core/data/puzzle/model/model_map.dart';
import 'entity_position.dart';

//Todo: STRING hard coded
class MapEntity {
  List<String> rows;
  int _starsLeft;
  Set<PositionEntity> stops;
  ShipEntity ship;

  int get maxRow => rows.length;
  int get maxCol => rows.first.length;
  double get aspectRatio => (maxCol / maxRow);
  int get casesNumber => maxRow * maxCol;
  bool get noStarsLeft => _starsLeft < 1;
  int get starsLeft => _starsLeft;
  String operator [] (int rowIndex) => rows[rowIndex];
  final voidChar = ' ';
  static MapEntity get empty => MapEntity(rows: [], ship: ShipEntity.none(), starsTotal: 0);

  MapEntity({
    required this.rows,
    required this.ship,
    Set<PositionEntity>? stops,
    int? starsTotal,
  }) : stops = stops ?? {},
        _starsLeft = starsTotal ?? getStarsPositions(rows);

  factory MapEntity.from({
    required MapModel model,
    required PositionEntity position,
    required DirectionEntity direction,
  }) => MapEntity(
    rows: model.rows,
    ship: ShipEntity(pos: position, dir: direction)
  );


  MapEntity copyWith({
    List<String>? rows,
    ShipEntity? ship,
    int? starsTotal,
    Set<PositionEntity>? stops,
  }) => MapEntity(
    rows: rows?.copy ?? this.rows.copy,
    ship: ship?.copy ?? this.ship.copy,
    starsTotal: starsTotal ?? _starsLeft,
    stops: stops?.copy ?? this.stops.copy,
  );
  MapEntity get copy => copyWith();

  /// getting the list of all the stars on the map represented by lowercases
  static int getStarsPositions(List<String> rows) {
    // print('MapEntity.getStarsPositions - ');
    Set<PositionEntity> starPositions = {};
    for (var (rowNumber, row) in rows.indexed) {
      for (int colNumber = 0; colNumber < row.length; colNumber++) {
        if (row[colNumber] == 'r' || row[colNumber] == 'b' || row[colNumber] == 'g') {
          starPositions.add(PositionEntity(row: rowNumber, col: colNumber));
        }
      }
    }
    if (starPositions.isEmpty) throw Exception('MapEntity - getStarsPosition - empty stars list \n${rows.join('\n')}');
    return starPositions.length;
  }

  /// toggle the case where the player avatar should stop at
  MapEntity addOrRemoveStopAt(PositionEntity position) {
    stops.contains(position) ? stops.remove(position) : stops.add(position);
    return copy;
  }

  /// remove or add a star in the list and on the characters map
  void addOrRemoveStarAt(PositionEntity position) {
    if (charAt(position).isLowerCase) {
      _starsLeft--;
      // stars.remove(position);
      rows[position.row] = rows[position.row].replaceCharAt(position.col, charAt(position).toUpperCase());
    } else {
      _starsLeft++;
      // stars.add(position);
      rows[position.row].replaceCharAt(position.col, charAt(position).toLowerCase());
    }
  }

  /// returning the Letter representing the map case
  String getCaseLetter(PositionEntity pos) => rows[pos.row][pos.col];

  /// check if this position is a stop mark
  bool containStopMark(PositionEntity pos) => stops.contains(pos);

  /// get a 2D indexes from a 1D index
  PositionEntity getPositionBy({required linearIndex}) => PositionEntity(row: linearIndex ~/ rows.first.length , col: linearIndex % rows.first.length);

  /// getting the aspect ratio of the 2D map

  /// check if the direction get the ship out of the map
  bool isDirectionValid(ShipEntity ship) {
    switch (ship.dir) {
      case DirectionEntity.est when ship.pos.col == maxRow: return false;
      case DirectionEntity.west when ship.pos.col < 0: return false;
      case DirectionEntity.south when ship.pos.row == maxCol: return false;
      case DirectionEntity.north when ship.pos.row < 0: return false;
      case _ : return true;
    }
  }

  /// replace a map case
  MapEntity colorChangeAt(CaseColorEntity color) {
    rows[ship.pos.row] = rows[ship.pos.row].replaceCharAt(ship.pos.col, color.toString());
    return copy;
  }

  /// check if the position is inside on non playable case
  bool isOnValidCase(PositionEntity playerPosition) => rows[playerPosition.row][playerPosition.col] != voidChar
      && (0 <= playerPosition.row && playerPosition.row < maxRow)
      && (0 <= playerPosition.col && playerPosition.col < maxCol) ;

  /// checking the action color case match the map case color
  bool isMapCaseMatchingColor(ActionEntity action, PositionEntity position) => action.color == CaseColorEntity.grey
  || rows[position.row][position.col].equalsIgnoreCase(action.color.toString());

  /// checking if a star is present this position
  bool containStarAt(PositionEntity pos) => rows[pos.row][pos.col].isLowerCase;

  /// returning the Letter representing the map case
  String charAt(PositionEntity position) => rows[position.row][position.col];

  @override
  String toString() {
    String firstLine = '   ' + List.generate(rows.first.length, (index) => index.toString().padLeft(2, ' ')).join(' ') + '\n';
    String map = List.generate(rows.length, (rowNumber) {
        String row = rows[rowNumber].split('').map((c) {switch(c) {
      case 'r' || 'R' : return strRed(c);
      case 'g' || 'G' : return strGreen(c);
      case 'b' || 'B' : return strBlue(c);
      case ' ' : return '.';
      case _ : return c;
      }}).map((s) => ' $s ').join();
        String rowPrefix = rowNumber.toString().padLeft(2, ' ');
        return '$rowPrefix $row';  }
      ).join('\n');
    return firstLine + map;
  }

  /// removing empty columns and empty rows and padd the path with a layer of empty case and apply the modification to ship position
  void cleanRows() {
    List<int> rowsIndexToRemove = _getEmptyLinesIndex(rows);
    for (final i in rowsIndexToRemove.reversed) { rows.removeAt(i); }

    int rowOffset = rowsIndexToRemove.where((i) => i <= ship.pos.row).length * -1;
    ship = ship.movePosition(rowOffset: rowOffset);

    List<String> cols = rows.switchHorizontalAndVertical();
    List<int> colsIndexToRemove = _getEmptyLinesIndex(cols);
    int colOffset = colsIndexToRemove.where((i) => i <= ship.pos.col).length * -1;
    ship = ship.movePosition(colOffset: colOffset);
    for (final i in colsIndexToRemove.reversed) { cols.removeAt(i); }

    final emptyCol = voidChar * cols.first.length;
    cols.insert(0, emptyCol);
    cols.add(emptyCol);
    ship = ship.movePosition(colOffset: 1);

    rows = cols.switchHorizontalAndVertical();
    final emptyRow = voidChar * rows.first.length;
    rows.insert(0, emptyRow);
    rows.add(emptyRow);
    ship = ship.movePosition(rowOffset: 1);
  }

  /// return list of empty lines index in a list of string
  List<int> _getEmptyLinesIndex(List<String> lines) => List.generate(lines.length, (i) => i)
      .where((i) => lines[i].trim().isEmpty).toList();
}