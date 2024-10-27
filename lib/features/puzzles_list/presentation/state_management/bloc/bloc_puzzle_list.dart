import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/list.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_puzzle.dart';
import 'package:robuzzle/features/puzzles_list/domain/entities/entity_puzzle_list.dart';
import 'package:robuzzle/features/puzzles_list/domain/usecases/usecase_get_puzzle_id_finished_by_diff.dart';
import 'package:robuzzle/features/puzzles_list/domain/usecases/usecase_get_puzzle_id_list_by_diff.dart';
import 'package:robuzzle/features/puzzles_list/domain/usecases/usecase_get_puzzle_id_list_fav_by_diff.dart';
import 'package:robuzzle/features/puzzles_list/domain/usecases/usecase_get_puzzle_list.dart';
import 'package:robuzzle/features/puzzles_list/presentation/state_management/bloc/state_puzzle_list.dart';

import '../../../../../core/log/consolColors.dart';
import '../../../domain/usecases/usecase_set_puzzle_id_list_fav_by_diff.dart';
import 'event_puzzle_list.dart';

//Todo: String Hard coded
class PuzzleListBloc extends Bloc<PuzzleListEvent, PuzzleListState> {
  final GetPuzzleIdListByDiffUseCase getPuzzleIdSetUseCase;
  final GetPuzzleIdListFinishedByDiffUseCase getPuzzleFinishedIdSetUseCase;
  final GetPuzzleEntityListById getPuzzleSetUseCase;
  final GetPuzzleIdListFavByDiffUseCase getPuzzleFavIdSetUseCase;
  final SetPuzzleIdListFavByDiffUseCase setPuzzleFavIdSetUseCase;
  int trollCount = 0;

  PuzzleListBloc({
    required this.getPuzzleIdSetUseCase,
    required this.getPuzzleFinishedIdSetUseCase,
    required this.getPuzzleSetUseCase,
    required this.getPuzzleFavIdSetUseCase,
    required this.setPuzzleFavIdSetUseCase,
  }) : super( PuzzleListStateLoading() ) {
    on<PuzzleListEventLoad>(_loadPuzzleList);
    on<PuzzleListEventRemoveFav>(_removeFav);
    on<PuzzleListEventAddFav>(_addFav);
    on<PuzzleListEventSelectFavList>(_displayFavoritesPuzzles);
    on<PuzzleListEventSelectAllList>(_displayAllPuzzles);
  }

  /// removing a puzzle from the favorite list in the ui and state
  /// also removing the id from the local data source
  void _removeFav(PuzzleListEventRemoveFav event, Emitter<PuzzleListState> emit) {
    try {
      final currentState = state as PuzzleListStateLoaded;
      final PuzzleListEntity newFavorite = currentState.list.singleWhere((e) => e.puzzle.id == event.id);
      final List<PuzzleListEntity> newFavorites = currentState.favorites.copy;
      if (newFavorites.contains(newFavorite)) {
        newFavorites.remove(newFavorites.singleWhere((e) => e.puzzle.id == event.id));
        final Set<int> newIds = newFavorites.map((e) => e.puzzle.id).toSet();
        setPuzzleFavIdSetUseCase.call(newIds, currentState.difficulty);
        switch (currentState) {
          case PuzzleListStateLoadedAll(): emit(PuzzleListStateLoadedAll(
            list: currentState.list.copy,
            favorites: newFavorites,
            difficulty: currentState.difficulty,
          ));
          case PuzzleListStateLoadedFav(): emit(PuzzleListStateLoadedFav(
            list: currentState.list.copy,
            favorites: newFavorites,
            difficulty: currentState.difficulty,
          ));
        }
      }
    } catch (e) {
      _triggerError(emit, state, event, e);
    }
  }

  /// adding a puzzle from the favorite list in the ui and state
  /// also adding the id from the local data source
  void _addFav(PuzzleListEventAddFav event, Emitter<PuzzleListState> emit) {
    try {
      final currentState = state as PuzzleListStateLoaded;
      final PuzzleListEntity newFavorite = currentState.list.singleWhere((e) => e.puzzle.id == event.id);
      final List<PuzzleListEntity> newFavorites = currentState.favorites.copy;
      if (!newFavorites.contains(newFavorite)) {
        newFavorites.add(newFavorite);
        if (newFavorites.length == 1) newFavorites.insert(0, PuzzleListEntity.empty);
        final Set<int> newIds = newFavorites.map((e) => e.puzzle.id).toSet();
        setPuzzleFavIdSetUseCase.call(newIds, currentState.difficulty);
        switch (currentState) {
          case PuzzleListStateLoadedAll(): emit(PuzzleListStateLoadedAll(
            list: currentState.list.copy,
            favorites: newFavorites.copy,
            difficulty: currentState.difficulty,
          ));
          case PuzzleListStateLoadedFav(): emit(PuzzleListStateLoadedFav(
            list: currentState.list.copy,
            favorites: newFavorites.copy,
            difficulty: currentState.difficulty,
          ));
        }
      }
    } catch (e) {
      _triggerError(emit, state, event, e);
    }
  }

  /// Modifying the state to display favorites puzzles list
  void _displayFavoritesPuzzles(PuzzleListEventSelectFavList event, Emitter<PuzzleListState> emit) {
    try {
      final currentState = state as PuzzleListStateLoaded;
      emit(PuzzleListStateLoadedFav(
        list: currentState.list.copy,
        favorites: currentState.favorites.copy,
        difficulty: currentState.difficulty,
      ));
    } catch (e) {
      _triggerError(emit, state, event, e);
    }
  }

  /// Modifying the state to display all puzzles list
  void _displayAllPuzzles(PuzzleListEventSelectAllList event, Emitter<PuzzleListState> emit) {
    try {
      final currentState = state as PuzzleListStateLoaded;
      emit(PuzzleListStateLoadedAll(
        list: currentState.list.copy,
        favorites: currentState.favorites.copy,
        difficulty: currentState.difficulty,
      ));
    } catch (e) {
      _triggerError(emit, state, event, e);
    }
  }

  /// Loading all the id puzzles for this difficulty
  /// Loading all the favorites id puzzles for this difficulty
  /// Loading all the finished id puzzles for this difficulty
  /// Updating the state so UI can display the list
  void _loadPuzzleList(PuzzleListEventLoad event, Emitter<PuzzleListState> emit) async {
    final Set<int> puzzleIds = await getPuzzleIdSetUseCase.call(event.difficulty);
    if (puzzleIds.isEmpty) _triggerError(emit, state, event, Exception('PuzzleListBloc._loadPuzzleList puzzleIds list is empty'));
    final Set<int> puzzleFinishedIds = await getPuzzleFinishedIdSetUseCase.call(event.difficulty);

    final Set<int> puzzlesFavIds = await getPuzzleFavIdSetUseCase.call(event.difficulty);
    final Set<PuzzleEntity> puzzles = await getPuzzleSetUseCase.execute(puzzleIds);
    if (puzzles.isEmpty) _triggerError(emit, state, event, Exception('PuzzleListBloc._loadPuzzleList puzzles list is empty'));
    final List<PuzzleListEntity> list = [];
    final List<PuzzleListEntity> favorites = [];
    for (final puzzle in puzzles) {
      bool finished = false;
      if (puzzleFinishedIds.contains(puzzle.id)) {
        finished = true;
        puzzleFinishedIds.remove(puzzle.id);
      }
      final listElement = PuzzleListEntity(puzzle: puzzle, finished: finished,);
      list.add(listElement.copy);
      if (puzzlesFavIds.contains(puzzle.id)) {
        favorites.add(listElement.copy);
        puzzlesFavIds.remove(puzzle.id);
      }
    }
    if (list.isNotEmpty) list.insert(0, PuzzleListEntity.empty);
    if (favorites.isNotEmpty) favorites.insert(0, PuzzleListEntity.empty);
    emit(PuzzleListStateLoadedAll(
      list: list,
      favorites: favorites,
      difficulty: event.difficulty,
    ));
  }

  void _triggerError(Emitter<PuzzleListState> emit, PuzzleListState state, PuzzleListEvent event, Object error)
  => emit(PuzzleListStateStateError(message: 'At state -> ${state.runtimeType.toString()}\n'
      'Calling event -> ${event.runtimeType}\n'
      '${error.toString()}'
  ));
}