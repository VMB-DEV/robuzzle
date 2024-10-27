import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/level/bloc_level.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/level/state_level.dart';
import 'package:robuzzle/features/settings/presentation/bloc/bloc_settings.dart';
import 'package:robuzzle/features/settings/presentation/bloc/state_settings.dart';

import '../../../../../core/log/consolColors.dart';
import '../../../../../core/widgets/UnknownStateWidget.dart';
import '../../../domain/entities/progress/action/entity_action.dart';
import '../../../domain/entities/puzzle/entity_position.dart';
import '../../state_management/bloc/functions/bloc_functions.dart';
import '../../state_management/bloc/functions/event_functions.dart';
import '../../state_management/bloc/functions/state_functions.dart';
import '../action_case/action_case.dart';
import '../page_level.dart';
import 'drag_and_drop_menu.dart';

//Todo : Hard Coded int
class ActionMenuWidget extends StatelessWidget {
  final PositionEntity actionToModifyPosition;
  const ActionMenuWidget({required this.actionToModifyPosition, super.key});

  Widget _actionRemove(ActionEntity action, BuildContext context, bool darkFilter) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 10),
    child: ActionCase(
      action: action,
      size: boxSizeStatic.toInt(),
      darkFilter: darkFilter,
      onTap: () {
        context.read<FunctionsBloc>().add(FunctionsEventMenuSelectAction( actionSelected: action));
        Navigator.of(context).pop();
      },
    ),
  );

  Widget _actionDragAndDrop(FunctionsState state, ActionEntity action, int rowNumber, int colNumber, bool leftHanded) {
    final bool darkFilter = state is FunctionsStateMenuDraggingAction && !state.actionDragged.canMergeWith(action);
    final bool droppableItem = state is FunctionsStateMenuDraggingAction && state.actionDragged.canMergeWith(action);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 10),
      child: MenuActionCaseDragAndDrop(
        action: action,
        position: PositionEntity(row: rowNumber, col: colNumber),
        droppable: droppableItem,
        darkFilter: darkFilter,
        leftHanded: leftHanded,
      ),
    );
  }

    Widget _buildLayout(LevelStateLoaded levelState, FunctionsStateLoaded functionState, bool leftHanded) {
      // if (levelState is LevelStateLoaded) {
        return LayoutBuilder(builder: (context, box) {
          return Container(
            width: box.W * 0.75 < box.H * 0.8 ? box.W * 0.75 : box.H * 0.8,
            height: boxSizeStatic * 5 + 10 * 4 * 1.3,
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade600,
              border: Border.all(color: Colors.blueGrey.shade900, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: Center( child: IntrinsicWidth( child: Column(
                children: List.generate(levelState.level.menu.rows.length, (rowNumber) {
                  return Center( child: IntrinsicWidth( child: Row(
                    children: List.generate(levelState.level.menu.rows[rowNumber].length, (colNumber) {
                      final ActionEntity action = levelState.level.menu.rows[rowNumber][colNumber];
                      final bool darkFilter = functionState is FunctionsStateMenuDraggingAction;
                      return action == ActionEntity.remove
                          ? _actionRemove(action, context, darkFilter)
                          : _actionDragAndDrop(functionState, action, rowNumber, colNumber, leftHanded);
                    }),
                  ),),);
                }),
              ),),),
            ),
          );
        });
      // } else {
      //   return UnknownStateWidget(stateName: levelState.runtimeType.toString());
      // }
    }

    @override
    Widget build(BuildContext context) {
      return BlocSelector<SettingsBloc, SettingsState, SettingsStateLoaded>(
        selector: (settingsState) => settingsState as SettingsStateLoaded,
        builder: (context, settingsState) {
          return BlocSelector<LevelBloc, LevelState, LevelStateLoaded>(
            selector: (levelState) => levelState as LevelStateLoaded,
            builder: (context, levelState) {
              return BlocSelector<FunctionsBloc, FunctionsState, FunctionsStateLoaded>(
                selector: (functionState) => functionState as FunctionsStateLoaded,
                builder: (context, functionState) {
                  return _buildLayout(levelState, functionState, settingsState.settings.leftHanded);
                },
              );
            },
          );
        },
      );
    }
}
