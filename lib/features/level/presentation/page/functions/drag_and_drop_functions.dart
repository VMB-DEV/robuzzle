import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/log/consolColors.dart';
import '../../../domain/entities/progress/action/entity_action.dart';
import '../../../domain/entities/puzzle/entity_position.dart';
import '../../state_management/bloc/functions/bloc_functions.dart';
import '../../state_management/bloc/functions/event_functions.dart';
import '../action_case/action_case.dart';
import '../action_case/action_case_drag_drop.dart';
import '../action_menu/popup_route_menu.dart';
import '../action_menu/widget_menu.dart';
import '../page_level.dart';

class FunctionActionCaseDragAndDrop extends DragAndDropItem {
  final bool borders;

  FunctionActionCaseDragAndDrop({
    required super.action,
    required super.position,
    required super.darkFilter,
    required super.leftHanded,
    required this.borders,
    super.draggable,
    super.key,
  });

  @override
  State<DragAndDropItem> createState() => _FunctionActionCaseDragAndDropState(borders);
}

class _FunctionActionCaseDragAndDropState extends DragAndDropItemState {
  final bool borders;

  // _FunctionActionCaseDragAndDropState(super.action, super.position, this.borders, super.darkFilter);
  _FunctionActionCaseDragAndDropState(this.borders);

  @override
  bool onWillAcceptWithDetails() {
    setState(() => itemOnTopState = true);
    return true;
  }

  @override
  void onTargetAccept() {
    context.read<FunctionsBloc>().add(FunctionsEventSwitchActions(actionTargetedPosition: widget.position));
    setState(() => itemOnTopState = false);
  }

  @override
  void onDragStarted() => context.read<FunctionsBloc>().add(FunctionsEventDragActionFunction(actionPosition: widget.position));
  @override
  void onDragCanceled() => context.read<FunctionsBloc>().add(FunctionsEventDragCanceled());
  @override
  onStaticItemTap() => () {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    context.read<FunctionsBloc>().add(FunctionsEventMenuPop(actionPosition: widget.position));
    showCustomMenuPopup(context, child: ActionMenuWidget(actionToModifyPosition: widget.position), origin: offset);
  };

  @override
  Widget buildOnDragWidget() => ActionCase(
    action: widget.action,
    size: boxSizeStatic.toInt(),
    whiteBorders: true,
    // onTap: () {},
  );
  @override
  Widget buildOnDragLeftWidget() => Stack(children: [
    ActionCase(
      action: ActionEntity.noAction,
      size: boxSizeStatic.toInt(),
      // onTap: () {},
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
  Widget buildStaticItem() => Container(
    child: ActionCase(
      action: widget.action,
      size: boxSizeStatic.toInt(),
      whiteBorders: borders ? true : itemOnTopState,
      onTap: onStaticItemTap(),
      darkFilter: widget.darkFilter,
    ),
  );
}
