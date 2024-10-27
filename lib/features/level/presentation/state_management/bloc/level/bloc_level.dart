import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/log/consolColors.dart';
import 'package:robuzzle/easyTesting.dart';
import 'package:robuzzle/features/level/domain/entities/progress/entity_functions.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/functions/state_functions.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/bloc_in_game.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/event_in_game.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/state_in_game.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/level/event_level.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/level/state_level.dart';

import '../../../../domain/entities/level/entity_level.dart';
import '../../../../domain/entities/progress/entity_progress.dart';
import '../../../../domain/usecases/usecase_get_level.dart';
import '../../../../domain/usecases/usecase_set_progress.dart';
import '../../../../domain/usecases/usecase_set_win.dart';
import '../functions/bloc_functions.dart';
import '../functions/event_functions.dart';

class LevelBloc extends Bloc<LevelEvent, LevelState> {
  final GetLevelUseCase getLevelUseCase;
  final SetProgressUseCase setProgressUseCase;
  final FunctionsBloc functionsBloc;
  final InGameBloc inGameBloc;
  final SetWinUseCase setWinUseCase;

  LevelBloc({
    required this.getLevelUseCase,
    required this.setProgressUseCase,
    required this.functionsBloc,
    required this.inGameBloc,
    required this.setWinUseCase,
  }) : super(LevelStateLoading()) {
    on<LevelEventLoadLevelByID>(_loadLevelByID);
    functionsBloc.stream.listen(_listenToFunctionsState);
    inGameBloc.stream.listen(_listenToGame);
  }

  /// listening if the game has been won
  void _listenToGame(InGameState inGameState) {
    try {
      final currentState = state as LevelStateLoaded;
      if (inGameState is InGameStateWin) {
        Log.grey('LevelBloc._listenToGame - ');
        setWinUseCase.execute(currentState.level.id, currentState.difficulty);
      }
    } catch (e) {
      Log.red('LevelBloc._listenToGame - ${state.runtimeType}');
    }
  }

  /// listening if the functions has been changed so the game prediction might be modified
  /// and the functions saved
  void _listenToFunctionsState(FunctionsState functionState) {
    if (functionState is FunctionsStateUpdated) {
      _saveFunctionsToLocalData(functionState);
      _updateFunctionsForInGameBloc(functionState.functions);
    }
  }

  void _updateFunctionsForInGameBloc(FunctionsEntity newFunctions) {
    Log.grey('LevelBloc._updateFunctionForInGameBloc - ');
    inGameBloc.add(InGameEventNewFunctions(functions: newFunctions));
  }

  void _saveFunctionsToLocalData(FunctionsStateUpdated functionState) {
    Log.grey('LevelBloc._saveFunctionsToLocalData - ');
    final currentState = state as LevelStateLoaded;
    final progress = ProgressEntity(
      id: currentState.level.id,
      functions: functionState.functions,
      isWin: false,
    );
    Log.white('LevelBloc._saveFunctionsToLocalData - p ${progress.toString()}');
    setProgressUseCase.execute(progress);
  }

  /// load the level and update state of Functions and InGameBloc
  Future<void> _loadLevelByID(LevelEventLoadLevelByID event, Emitter<LevelState> emit) async {
    Log.grey('LevelBloc._loadLevelByID - ');
    emit(LevelStateLoading());
    try {
      final LevelEntity level = await getLevelUseCase.call(event.id);
      Log.white('LevelBloc._loadLevelByID - f ${level.functions.toString()}');
      solutionById(level.id, level.functions);
      emit(LevelStateLoaded(level, event.difficulty));
      inGameBloc.add(InGameEventLoadLevel(level: level.copy));
      functionsBloc.add(FunctionsEventLoad(functions: level.functions.copy));
    } catch (e, stackTrace) {
      _triggerError(emit, state, event, e);
    }
  }

  void _triggerError(Emitter<LevelState> emit, LevelState state, LevelEvent event, Object error) => emit(
    LevelStateError( message: 'At state -> ${state.runtimeType.toString()}\n'
        'Calling event -> ${event.runtimeType}\n'
        '${error.toString()}'
    ),
  );
}
