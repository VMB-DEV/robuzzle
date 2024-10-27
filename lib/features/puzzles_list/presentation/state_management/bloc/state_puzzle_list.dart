import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:robuzzle/features/puzzles_list/domain/entities/entity_puzzle_list.dart';

sealed class PuzzleListState extends Equatable {
  @override
  List<Object> get props => [];
}

class PuzzleListStateLoading extends PuzzleListState {}

class PuzzleListStateStateError extends PuzzleListState {
  final String message;

  PuzzleListStateStateError({required this.message});

  @override
  List<Object> get props => [message];
}

sealed class PuzzleListStateLoaded extends PuzzleListState {
  final int difficulty;
  final List<PuzzleListEntity> list;
  final List<PuzzleListEntity> favorites;

  PuzzleListStateLoaded({
    required this.difficulty,
    required this.list,
    required this.favorites,
  });

  @override
  List<Object> get props => [list, favorites];
}
class PuzzleListStateLoadedAll extends PuzzleListStateLoaded {
  PuzzleListStateLoadedAll({required super.list, required super.favorites, required super.difficulty});
}

class PuzzleListStateLoadedFav extends PuzzleListStateLoaded {
  PuzzleListStateLoadedFav({required super.list, required super.favorites, required super.difficulty});
}
