import 'package:equatable/equatable.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_actions_list.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_level.dart';

sealed class InGameState extends Equatable { }

class InGameStateLoading extends InGameState {
  @override
  List<Object?> get props => [];
}

class InGameStateError extends InGameState {
  final String message;
  InGameStateError({required this.message});

  @override
  List<Object?> get props => [message];
}

class InGameStateLoaded extends InGameState {
  final LevelEntity level;
  final ActionsListEntity actionsList;

  InGameStateLoaded({
    required this.level,
    required this.actionsList,
  });

  @override
  List<Object?> get props => [level, actionsList];
}

sealed class InGameStateMoving extends InGameStateLoaded {
  InGameStateMoving({ required super.level, required super.actionsList, });
}

class InGameStateOnPause extends InGameStateMoving {
  InGameStateOnPause({ required super.level, required super.actionsList, });
}

class InGameStateOnPauseInLoop extends InGameStateOnPause {
  InGameStateOnPauseInLoop({ required super.level, required super.actionsList, });
}

class InGameStateOnPlay extends InGameStateMoving {
  InGameStateOnPlay({ required super.level, required super.actionsList, });
}

class InGameStateWin extends InGameStateMoving {
  InGameStateWin({ required super.level, required super.actionsList, });
}
