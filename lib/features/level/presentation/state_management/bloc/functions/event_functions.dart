import 'package:equatable/equatable.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_level.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_action.dart';
import 'package:robuzzle/features/level/domain/entities/progress/entity_functions.dart';
import 'package:robuzzle/features/level/domain/entities/puzzle/entity_position.dart';

abstract class FunctionsEvent extends Equatable {
  @override
  List<Object> get props => [];
}


/// called when user start dragging an case of the functions rows
class FunctionsEventLoad extends FunctionsEvent {
  final FunctionsEntity functions;
  FunctionsEventLoad({required this.functions});

  @override
  List<Object> get props => [functions];
}

class FunctionsEventDragActionFunction extends FunctionsEvent {
  final PositionEntity actionPosition;
  FunctionsEventDragActionFunction({required this.actionPosition});
}

/// called when user cancel the action menu selection
class FunctionsEventMenuCancel extends FunctionsEvent { FunctionsEventMenuCancel(); }

/// called when user pop the actions menu selection to store the action function position
class FunctionsEventMenuPop extends FunctionsEvent {
  final PositionEntity actionPosition;
  FunctionsEventMenuPop({required this.actionPosition});
}

/// called to switch action from functions rows
class FunctionsEventSwitchActions extends FunctionsEvent {
  final PositionEntity actionTargetedPosition;
  FunctionsEventSwitchActions({
    required this.actionTargetedPosition,
  });

  @override
  List<Object> get props => [actionTargetedPosition];
}

/// called when user start dragging an case from the actions selection menu
class FunctionsEventMenuDragAction extends FunctionsEvent {
  final ActionEntity action;
  FunctionsEventMenuDragAction({required this.action});
}

/// called in the menu selection to select the action and put in the functions
class FunctionsEventMenuSelectAction extends FunctionsEvent {
  final ActionEntity actionSelected;
  FunctionsEventMenuSelectAction({ required this.actionSelected, });

  @override
  List<Object> get props => [ actionSelected, ];
}

/// called in the menu selection to merge instruction's and color's actions
class FunctionsEventMergeActions extends FunctionsEvent {
  final ActionEntity actionTargeted;
  FunctionsEventMergeActions({
    required this.actionTargeted,
  });

  @override
  List<Object> get props => [ actionTargeted, ];
}

/// called to put dragged action in the trash
class FunctionsEventRemoveAction extends FunctionsEvent {}

/// called when a dragged action failed to drop somewhere
class FunctionsEventDragCanceled extends FunctionsEvent {}

/// called when a dragged action failed to drop somewhere
class FunctionsEventMenuDragCanceled extends FunctionsEvent {}

/// called when user drag an action from the menu selection above the colored zones in
/// the background
class FunctionsEventMenuAboveDropZone extends FunctionsEvent {
  final ActionEntity actionToMergeWith;
  FunctionsEventMenuAboveDropZone({required this.actionToMergeWith});

  @override
  List<Object> get props => [actionToMergeWith];
}

/// called when the action from the menu selection leaves the colored drop zone
class FunctionsEventMenuLeaveDropZone extends FunctionsEvent { }