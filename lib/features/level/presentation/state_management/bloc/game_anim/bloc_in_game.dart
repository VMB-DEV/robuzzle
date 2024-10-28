import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_actions_list.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_ship.dart';
import 'package:robuzzle/features/level/domain/usecases/usecase_set_win.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/state_in_game.dart';

import '../../../../../../core/log/consolColors.dart';
import '../../../../domain/entities/progress/entity_functions.dart';
import '../../../../domain/entities/puzzle/entity_map.dart';
import 'event_in_game.dart';

int timing = 250;
// int timing = 500;

class InGameBloc extends Bloc<InGameEvent, InGameState> {
  Timer _animation = Timer.periodic(const Duration(), (_) {})..cancel();

  InGameBloc() : super(InGameStateLoading()) {
    on<InGameEventNewFunctions>(_newFunctions);
    on<InGameEventLoadLevel>(_loadLevel);
    on<InGameEventToggleMapCase>(_toggleMapCase);
    on<InGameEventPlay>(_startAnimation);
    on<InGameEventPause>(_pauseAnimation);
    on<InGameEventReset>(_resetAnimation);
    on<InGameEvenIndexUpdate>(_updateActionListIndex);
  }

  final _actionPositionStreamController = StreamController<FunctionsEntity>();
  StreamSink<FunctionsEntity> get actionPositionSink => _actionPositionStreamController.sink;
  Stream<FunctionsEntity> get actionPositionStream => _actionPositionStreamController.stream;


  /// launch the animation by looping through the actionList
  void _startAnimation( InGameEventPlay event, Emitter<InGameState> emit) async {
    try {
      final currentState = state as InGameStateLoaded;
      _animation.cancel();
      int currentIndex = currentState.actionsList.currentIndex;
      ShipEntity currentShip = currentState.actionsList.currentShip;
      int maxIndex = currentState.actionsList.lastIndex;
      _animation = Timer.periodic(Duration(milliseconds: timing), (timer) {
        currentIndex++;
        currentShip = currentState.actionsList.list[currentIndex].map.ship;
        if (currentIndex == maxIndex) {timer.cancel();}
        add(InGameEvenIndexUpdate(newIndex: currentIndex));
        if ( currentState.level.map.containStopMark(currentShip.pos) ) timer.cancel();
      });
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  /// stop the animation and modify the state to paused
  void _pauseAnimation(InGameEventPause event, Emitter<InGameState> emit) {
    try {
      _animation.cancel();
      final currentState = state as InGameStateLoaded;
      emit(InGameStateOnPause(
        level: currentState.level.copy,
        actionsList: currentState.actionsList.copy,
      ));
    } catch (e) {
      emit(InGameStateError(message: '${event.runtimeType} - ${e.toString()}'));
    }
  }

  /// stop the animation and reset it
  void _resetAnimation(InGameEventReset event, Emitter<InGameState> emit) {
    try {
      _animation.cancel();
      final currentState = state as InGameStateLoaded;
      // emit(InGameStateOnPause(
      emit(InGameStateOnPauseInLoop(
        level: currentState.level.copy,
        actionsList: currentState.actionsList.copyWith(currentIndex: 0),
      ));
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  /// update the index in the action list to make the animation and triggers states onPlay or on Plause depends on the timer status
  /// verify if the game has been won
  void _updateActionListIndex(InGameEvenIndexUpdate event, Emitter<InGameState> emit) {
    try {
      final currentState = state as InGameStateLoaded;
      final int newIndex = event.newIndex;
      if (currentState.actionsList.isWinIndex(newIndex)) {
        emit(InGameStateWin(
          level: currentState.level.copy,
          actionsList: currentState.actionsList.copyWith(currentIndex: currentState is InGameStateMoving ? newIndex : 0),
        ));
      } else if (_animation.isActive) {
        emit(InGameStateOnPlay(
          level: currentState.level.copy,
          actionsList: currentState.actionsList.copyWith(currentIndex: currentState is InGameStateMoving ? newIndex : 0),
        ));
      } else {
        emit(InGameStateOnPause(
          level: currentState.level.copy,
          actionsList: currentState.actionsList.copyWith(currentIndex: currentState is InGameStateMoving ? newIndex : 0),
        ));
      }

    } catch (e) { _triggerError(emit, state, event, e); }
  }

  /// updating the functions so the actionList can be recalculated
  void _newFunctions(InGameEventNewFunctions event, Emitter<InGameState> emit) {
    try {
      final currentState = state as InGameStateLoaded;
      final newLevel = currentState.level.copyWith(functions: event.functions);
      emit(InGameStateLoaded(
        level: newLevel,
        actionsList: ActionsListEntity.fromLevel(newLevel),
      ));
    } catch (e) {
      emit(InGameStateError(message: '${event.runtimeType} - ${e.toString()}'));
    }
  }

  /// load a new Level so the actionList can be updated base on it
  void _loadLevel(InGameEventLoadLevel event, Emitter<InGameState> emit) {
    try {
      emit(InGameStateLoaded(
        level: event.level.copy,
        actionsList: ActionsListEntity.fromLevel(event.level.copy),
      ));
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  /// trigger a map position where the animation will stop
  void _toggleMapCase(InGameEventToggleMapCase event, Emitter<InGameState> emit) {
    try {
      final currentState = state as InGameStateLoaded;
      final MapEntity newMap = currentState.level.map.addOrRemoveStopAt(event.position);
      if (state is InGameStateMoving) {
        final currentState = state as InGameStateMoving;
        switch (currentState) {
          case InGameStateOnPause():emit(InGameStateOnPause(
            level: currentState.level.copyWith(map: newMap),
            actionsList: currentState.actionsList,
          ));
          case InGameStateOnPlay(): emit(InGameStateOnPlay(
            level: currentState.level.copyWith(map: newMap),
            actionsList: currentState.actionsList,
          ));
          case _: {
            Log.red('InGameBloc._toggleMapCase - ${currentState.runtimeType}');
          }
        }
      } else {
        emit(InGameStateLoaded(
          level: currentState.level.copyWith(map: newMap),
          actionsList: currentState.actionsList,
        ));
      }
    } catch (e) { _triggerError(emit, state, event, e); }
  }

  void _triggerError(Emitter<InGameState> emit, InGameState state, InGameEvent event, Object error)
  => emit(InGameStateError(message: 'At state -> ${state.runtimeType.toString()}\n'
      'Calling event -> ${event.runtimeType}\n'
      '${error.toString()}'
  ));
}
