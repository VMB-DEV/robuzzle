import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class PuzzleListEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class PuzzleListEventLoad extends PuzzleListEvent {
  final int difficulty;
  PuzzleListEventLoad({required this.difficulty});

  @override
  List<Object> get props => [difficulty];
}

class PuzzleListEventAddFav extends PuzzleListEvent {
  final int id;
  PuzzleListEventAddFav({required this.id});

  @override
  List<Object> get props => [id];
}
class PuzzleListEventRemoveFav extends PuzzleListEvent {
  final int id;
  PuzzleListEventRemoveFav({required this.id});

  @override
  List<Object> get props => [id];
}

class PuzzleListEventSelectFavList extends PuzzleListEvent {
}
class PuzzleListEventSelectAllList extends PuzzleListEvent {
}
