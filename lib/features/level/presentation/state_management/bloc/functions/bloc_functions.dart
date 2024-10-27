import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_action.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_case_color.dart';
import 'package:robuzzle/features/level/domain/entities/progress/entity_functions.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/functions/event_functions.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/functions/state_functions.dart';


//Todo: STRING hard coded
class FunctionsBloc extends Bloc<FunctionsEvent, FunctionsState> {

  FunctionsBloc() : super(FunctionsStateLoading()) {
    on<FunctionsEventLoad>(_loadFunctions);
    on<FunctionsEventSwitchActions>(_switchActions);
    on<FunctionsEventRemoveAction>(_dragToTrash);
    on<FunctionsEventDragActionFunction>(_dragActionFunction);
    on<FunctionsEventDragCanceled>(_dragCanceled);
    on<FunctionsEventMenuPop>(_menuPop);
    on<FunctionsEventMenuDragAction>(_menuDragAction);
    on<FunctionsEventMenuDragCanceled>(_menuDragActionCanceled);
    on<FunctionsEventMenuAboveDropZone>(_menuDragAboveDropZone);
    on<FunctionsEventMenuLeaveDropZone>(_menuDragLeaveDropZone);
    on<FunctionsEventMergeActions>(_menuMergeActions);
    on<FunctionsEventMenuSelectAction>(_menuActionSelection);
    on<FunctionsEventMenuCancel>(_menuPopCancel);
  }

  /// adding the functions level in the state so events can later on manipulate it
  /// save the new functions to the local data
  void _loadFunctions(FunctionsEventLoad event, Emitter<FunctionsState> emit) {
    try {
      emit(FunctionsStateLoaded(functions: event.functions));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }


  /// trigger the popup menu so user can selection an action to put in the bar
  void _menuPop(FunctionsEventMenuPop event, Emitter<FunctionsState> emit ) async {
    print('FunctionsBloc._menuPop - ');
    try {
      final currentState = state as FunctionsStateLoaded;
      emit(FunctionsStateMenuPopup(
        actionPositionStored: event.actionPosition,
        functions: currentState.functions.copy,
      ));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  /// menu selection of an action
  /// use the selected action in state and replace it with the one in the event
  void _menuActionSelection(FunctionsEventMenuSelectAction event, Emitter<FunctionsState> emit) async {
    try {
      final currentState = state as FunctionsStateWithPosition;
      if (event.actionSelected == ActionEntity.remove) {
        final newFunctions = currentState.functions.replace(position: currentState.actionPositionStored, menuAction: ActionEntity.noAction);
        emit(FunctionsStateUpdated(functions: newFunctions));
      } else {
        final newAction = event.actionSelected == ActionEntity.remove ? ActionEntity.noAction : event.actionSelected;
        final newFunctions = currentState.functions.replaceFromMenu(position: currentState.actionPositionStored, menuAction: newAction);
        emit(FunctionsStateUpdated(functions: newFunctions));
      }
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  /// change the state to Drag and use this new state to store the position of the dragged action
  void _dragActionFunction(FunctionsEventDragActionFunction event, Emitter<FunctionsState> emit) async {
    try {
      final currentState = state as FunctionsStateLoaded;
      emit( FunctionsStateDraggingActionFunction(
        actionPositionStored: event.actionPosition,
        functions: currentState.functions.copy,
      ));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }


  /// change the state to Drag and use this new state to store the dragged action and type of drag it will be
  /// because if the use drag an instruction without color he could do a quick merge with a color outside the menu box
  void _menuDragAction(FunctionsEventMenuDragAction event, Emitter<FunctionsState> emit) async {
    try {
      // final currentState = state as FunctionsStateWithPosition;
      final currentState = state as FunctionsStateMenuPopup;
      final canMergeWithColor = event.action.color == CaseColorEntity.grey;
      emit(FunctionsStateMenuDraggingAction(
        actionDragged: event.action,
        mergeWithColor: canMergeWithColor,
        actionPositionStored: currentState.actionPositionStored,
        functions: currentState.functions,
      ));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  void _menuDragActionCanceled(FunctionsEventMenuDragCanceled event, Emitter<FunctionsState> emit) async {
    try {
      final currentState = state as FunctionsStateMenuDraggingAction;
      emit(FunctionsStateMenuPopup(functions: currentState.functions, actionPositionStored: currentState.actionPositionStored));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }
  
  void _menuDragAboveDropZone(FunctionsEventMenuAboveDropZone event, Emitter<FunctionsState> emit) {
    try {
      final currentState = state as FunctionsStateMenuDraggingAction;
      emit(FunctionStateMenuDraggingActionAboveDropZone(
        actionDragged: currentState.actionDragged,
        mergeWithColor: currentState.mergeWithColor,
        actionPositionStored: currentState.actionPositionStored,
        functions: currentState.functions,
        actionToMergeWith: event.actionToMergeWith,
      ));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  /// restoring the menu selection dragging state
  void _menuDragLeaveDropZone(FunctionsEventMenuLeaveDropZone event, Emitter<FunctionsState> emit) {
    try {
      final currentState = state as FunctionsStateMenuDraggingAction;
      emit(FunctionsStateMenuDraggingAction(
        actionDragged: currentState.actionDragged.copy,
        mergeWithColor: currentState.mergeWithColor,
        actionPositionStored: currentState.actionPositionStored.copy,
        functions: currentState.functions.copy,
      ));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  /// merging instructions with colors to replace the selected action in the functions
  void _menuMergeActions(FunctionsEventMergeActions event, Emitter<FunctionsState> emit) async {
    try {
      final currentState = state as FunctionsStateMenuDraggingAction;
      final actionDragged = currentState.actionDragged;
      final actionTargeted = event.actionTargeted;
      if (actionDragged.canMergeWith(actionTargeted)) {
        final newAction = actionDragged.mergeWith(actionTargeted);
        final newFunctions = currentState.functions.replace( position: currentState.actionPositionStored, menuAction: newAction, );
        emit(FunctionsStateUpdated(functions: newFunctions));
      }
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  /// cancel the popup menu by cloning the function and so trigger a recomposition to remove the ui selection indication
  void _menuPopCancel(FunctionsEventMenuCancel event, Emitter<FunctionsState> emit) {
    print('FunctionsBloc._menuPopCancel - ');
    try {
      final currentState = state as FunctionsStateMenuPopup;
      emit(FunctionsStateUpdated(functions: currentState.functions.copy));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  /// switching actions in functions
  Future<void> _switchActions(FunctionsEventSwitchActions event, Emitter<FunctionsState> emit) async {
    //todo: if (state is LevelStatePaused)
    try {
      final currentState = state as FunctionsStateWithPosition;
      FunctionsEntity newFunctions = currentState.functions.switchActions(
        action1: currentState.actionPositionStored,
        action2: event.actionTargetedPosition,
      );
      emit(FunctionsStateUpdated(functions: newFunctions));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  /// removing the action dropped in the trash
  Future<void> _dragToTrash(FunctionsEventRemoveAction event, Emitter<FunctionsState> emit) async {
    try {
      final currentState = state as FunctionsStateWithPosition;
      final FunctionsEntity newFunctions = currentState.functions.removeAction(position: currentState.actionPositionStored);
      emit(FunctionsStateUpdated(functions: newFunctions));
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  /// make sure the state comes back to Loaded when a drag failed or has been canceled
  Future<void> _dragCanceled(FunctionsEventDragCanceled event, Emitter<FunctionsState> emit) async {
    print('FunctionsBloc._dragCanceled - ');
    try {
        final currentState = state as FunctionsStateWithPosition;
        emit(FunctionsStateUpdated(functions: currentState.functions.copy));
      // }
    } catch (error) {
      _triggerError(emit, state, event, error);
    }
  }

  void _triggerError(Emitter<FunctionsState> emit, FunctionsState state, FunctionsEvent event, Object error)
  => emit(FunctionsStateError( message: 'At state -> ${state.runtimeType.toString()}\n'
      'Calling event -> ${event.runtimeType}\n'
      '${error.toString()}',
  ),);
}
