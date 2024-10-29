import 'package:equatable/equatable.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_actions_list.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_level.dart';
import 'package:robuzzle/features/level/domain/entities/progress/entity_functions.dart';

import '../../../../domain/entities/puzzle/entity_position.dart';

sealed class InGameEvent extends Equatable { }

class InGameEventLoadLevel extends InGameEvent{
  final LevelEntity level;
  InGameEventLoadLevel({required this.level});

  @override
  List<Object?> get props => [level];
}

/// called to update the animation step index 
class InGameEvenIndexUpdate extends InGameEvent {
  final int newIndex;
  final bool onPause;
  InGameEvenIndexUpdate({required this.newIndex, this.onPause = false});

  @override
  List<Object?> get props => [newIndex];
}

/// called to launch the ship animation
class InGameEventPlay extends InGameEvent {
  @override
  List<Object?> get props => throw UnimplementedError('InGamePlay no props');
}

/// called to pause the ship animation
class InGameEventPause extends InGameEvent {
  @override
  List<Object?> get props => throw UnimplementedError('InGameEventPause.props');
}

/// called to reset the ship animation
class InGameEventReset extends InGameEvent {
  @override
  List<Object?> get props => throw UnimplementedError('InGameEventPause.props');
}

/// called when function rows has changes and trigger a new list of actions
class InGameEventNewFunctions extends InGameEvent {
  final FunctionsEntity functions;
  InGameEventNewFunctions({required this.functions});
  
  @override
  List<Object?> get props => [functions];
}

/// called to mark the level map with a stop mark
class InGameEventToggleMapCase extends InGameEvent {
  final PositionEntity position;
  InGameEventToggleMapCase({required this.position});

  @override
  List<Object> get props => [position];
}
