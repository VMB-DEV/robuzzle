import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/log/consolColors.dart';
import '../../../domain/entities/progress/action/entity_action.dart';
import '../../state_management/bloc/functions/bloc_functions.dart';
import '../../state_management/bloc/functions/event_functions.dart';
import '../action_case/action_case.dart';
import '../action_case/action_case_drag_drop.dart';
import '../page_level.dart';

class MenuActionCaseDragAndDrop extends DragAndDropItem {

  MenuActionCaseDragAndDrop({
    required super.action,
    required super.position,
    required super.droppable,
    required super.darkFilter,
    required super.leftHanded,
    super.key
  });

  @override
  State<DragAndDropItem> createState() => _MenuActionCaseDragAndDropState();
}

class _MenuActionCaseDragAndDropState extends DragAndDropItemState {
  _MenuActionCaseDragAndDropState();

  @override
  bool onWillAcceptWithDetails() {
    setState(() => itemOnTopState = true);
    return true;
  }

  @override
  void onTargetAccept() {
    Navigator.of(context).pop();
    context.read<FunctionsBloc>().add(FunctionsEventMergeActions(actionTargeted: widget.action));
    setState(() => itemOnTopState = false);
  }

  @override
  void onDragStarted() => context.read<FunctionsBloc>().add(FunctionsEventMenuDragAction(action: widget.action));

  @override
  void onDragCanceled() => mounted ? context.read<FunctionsBloc>().add(FunctionsEventMenuDragCanceled())
      : Log.red('_MenuActionCaseDragAndDropState.onDragCanceled can not add event');

  @override
  onStaticItemTap() => () {
    context.read<FunctionsBloc>().add(FunctionsEventMenuSelectAction(actionSelected: widget.action));
    Navigator.of(context).pop();
  };

  @override
  Widget buildOnDragWidget() => ActionCase(
    action: widget.action,
    side: boxSizeStatic.toInt() + 5,
    whiteBorders: true,
    // onTap: () {},
  );

  @override
  Widget buildOnDragLeftWidget() => Stack(children: [
    ActionCase(
      action: ActionEntity.noAction,
      side: boxSizeStatic.toInt(),
    ),
    Padding(
      padding: const EdgeInsetsDirectional.all(1),
      child: Container(
        width: boxSizeStatic - 2,
        height: boxSizeStatic - 2,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(3.5),
        ),
      ),
    ),
  ]);

  @override
  Widget buildStaticItem() => ActionCase(
    action: widget.action,
    side: boxSizeStatic.toInt(),
    whiteBorders: itemOnTopState,
    onTap: onStaticItemTap(),
    darkFilter: widget.darkFilter,
  );
}
