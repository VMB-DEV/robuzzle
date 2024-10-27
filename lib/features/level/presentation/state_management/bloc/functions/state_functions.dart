import 'package:equatable/equatable.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_level.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_action.dart';
import 'package:robuzzle/features/level/domain/entities/progress/entity_functions.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_position.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/level/state_level.dart';

sealed class FunctionsState extends Equatable {}

class FunctionsStateLoading extends FunctionsState {
  @override
  List<Object?> get props => [];
}

class FunctionsStateError extends FunctionsState {
  final String message;
  FunctionsStateError({required this.message});

  @override
  List<Object> get props => [message];
}

class FunctionsStateLoaded extends FunctionsState {
  final FunctionsEntity functions;
  FunctionsStateLoaded({required this.functions});

  @override
  List<Object> get props => [functions];
}
class FunctionsStateUpdated extends FunctionsStateLoaded {
  FunctionsStateUpdated({required super.functions});
}

abstract class FunctionsStateWithPosition extends FunctionsStateUpdated {
  final PositionEntity actionPositionStored;
  FunctionsStateWithPosition({ required this.actionPositionStored, required super.functions, });

  @override
  List<Object> get props => [functions, actionPositionStored];
}

class FunctionsStateDraggingActionFunction extends FunctionsStateWithPosition {
  FunctionsStateDraggingActionFunction({ required super.actionPositionStored, required super.functions, });
}


class FunctionsStateMenuPopup extends FunctionsStateWithPosition {
  FunctionsStateMenuPopup({ required super.actionPositionStored, required super.functions});
}

class FunctionsStateMenuDraggingAction extends FunctionsStateMenuPopup {
  final ActionEntity actionDragged;
  final bool mergeWithColor;

  FunctionsStateMenuDraggingAction({
    required this.actionDragged,
    required this.mergeWithColor,
    required super.actionPositionStored,
    required super.functions,
  });

  @override
  List<Object> get props => [ actionDragged, mergeWithColor, functions, ];
}

class FunctionStateMenuDraggingActionAboveDropZone extends FunctionsStateMenuDraggingAction {
  final ActionEntity actionToMergeWith;
  FunctionStateMenuDraggingActionAboveDropZone({
    required super.actionDragged,
    required super.mergeWithColor,
    required super.actionPositionStored,
    required super.functions,
    required this.actionToMergeWith,
  });
}
