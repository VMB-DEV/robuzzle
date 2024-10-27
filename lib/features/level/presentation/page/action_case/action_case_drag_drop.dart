import 'package:flutter/material.dart';
import '../../../domain/entities/progress/action/entity_action.dart';
import '../../../domain/entities/puzzle/entity_position.dart';

class DragAndDropItem extends StatefulWidget {
  final ActionEntity action;
  final PositionEntity position;
  final bool darkFilter;
  final bool droppable;
  final bool draggable;
  final bool leftHanded;

  const DragAndDropItem({
    required this.action,
    required this.position,
    required this.leftHanded,
    this.darkFilter = false,
    this.droppable = true,
    this.draggable = true,
    super.key
  });

  @override
  State<DragAndDropItem> createState() => DragAndDropItemState();
}

class DragAndDropItemState extends State<DragAndDropItem> {
  final Color opacityFilter = Colors.black54.withOpacity(0.5);
  final Offset _rightDraggableOffset = const Offset(-25, -30);
  final Offset _leftDraggableOffset = const Offset(25, -30);
  // final Offset _draggableOffset = const Offset(-25, -30);
  bool itemOnTopState = false;
  bool onWillAcceptWithDetails() => true;
  //todo: use final void
  void onDragStarted() {}
  void onDragCanceled() {}
  void onTargetAccept() {}
  VoidCallback onStaticItemTap() => () {};
  Widget buildOnDragWidget() => Container();
  Widget buildOnDragLeftWidget() => Container();
  Widget buildStaticItem() => Container(
    height: 10,
    width: 10,
    color: Colors.orange,
  );

  @override
  Widget build(BuildContext context) => buildDragAndDrop();

  Widget buildDragAndDrop() => widget.droppable ? DragTarget(
    hitTestBehavior: HitTestBehavior.translucent,
    onWillAcceptWithDetails: (details) => onWillAcceptWithDetails(),
    onLeave: (data) {
      setState(() {
        itemOnTopState = false;
      });
    },
    onAcceptWithDetails: (_) {
      setState(() => itemOnTopState = false);
      onTargetAccept();
    },
    builder: (context, _, __) => widget.draggable
        ? buildActionCaseDraggable(widget.action, itemOnTopState)
        : buildStaticItem(),
  ) : buildActionCaseDraggable(widget.action, itemOnTopState);

  Widget buildActionCaseDraggable(ActionEntity action, bool draggedItemOnTop) => Draggable<ActionEntity>(
  affinity: null,
  // Widget buildActionCaseDraggable(ActionEntity action, bool draggedItemOnTop) => LongPressDraggable<ActionEntity>(
  //   delay: const Duration(milliseconds: 0),
    hitTestBehavior: HitTestBehavior.translucent,
    maxSimultaneousDrags: 1,
    data: action,
    onDragStarted: onDragStarted,
    feedbackOffset: widget.leftHanded
        ? _leftDraggableOffset + const Offset(-10, -10)
        : _rightDraggableOffset + const Offset(-10, -10)
    ,
    feedback: RepaintBoundary(
      child: Transform.translate(
        offset: widget.leftHanded ? _leftDraggableOffset : _rightDraggableOffset,
        child: buildOnDragWidget(),
      ),
    ),
    onDraggableCanceled: (_, __) => onDragCanceled(),
    childWhenDragging: buildOnDragLeftWidget(),
    child: buildStaticItem(),
  );
}
