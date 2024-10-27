import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/features/level/presentation/page/functions/widget_glowing_trash_icon.dart';

import '../../state_management/bloc/functions/bloc_functions.dart';
import '../../state_management/bloc/functions/event_functions.dart';

class ActionCaseTrash extends StatefulWidget {
  final BoxConstraints constraints;
  const ActionCaseTrash(this.constraints, {super.key});

  @override
  State<ActionCaseTrash> createState() => _ActionCaseTrashState(constraints);
}

class _ActionCaseTrashState extends State<ActionCaseTrash> {
  final BoxConstraints box;
  bool _draggedItemOnTop = false;

  _ActionCaseTrashState(this.box);


  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    return _buildDroppable(
      orientation: orientation,
      child: _buildTrashUI(orientation),
    );
  }

  Widget _buildDroppable({required Widget child, required Orientation orientation}) {
    return Positioned(
      left: orientation == Orientation.portrait ? 0 : null,
      right: orientation == Orientation.portrait ? null : 0,
      child: DragTarget(
        hitTestBehavior: HitTestBehavior.translucent,
        onWillAcceptWithDetails: (details) {
          setState(() => _draggedItemOnTop = true);
          return true;
        },
        onLeave: (data) { setState(() => _draggedItemOnTop = false); },
        onAcceptWithDetails: (details) {
          setState(() => _draggedItemOnTop = false);
          context.read<FunctionsBloc>().add(FunctionsEventRemoveAction());
        },
        builder: (_, __, ___) => child,
      ),
    );
  }

  Widget _buildTrashUI(Orientation orientation) {
    return Container(
      height: box.H,
      alignment: Alignment.centerRight,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: _draggedItemOnTop ? box.W * 0.15 : box.W * 0.10,
        height: box.H * 0.95,
        decoration: BoxDecoration(
          color: Colors.red.withAlpha(_draggedItemOnTop ? 130 : 70),
          borderRadius: BorderRadius.only(
            topRight: orientation.isPortrait ? const Radius.elliptical(20, 15) : Radius.zero,
            bottomRight: orientation.isPortrait ? const Radius.elliptical(20, 15) : Radius.zero,
            topLeft: orientation.isPortrait ? Radius.zero : const Radius.elliptical(20, 15),
            bottomLeft: orientation.isPortrait ? Radius.zero : const Radius.elliptical(20, 15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withAlpha(_draggedItemOnTop ? 130 : 70),
              blurRadius: 2,
              spreadRadius: 0,
              blurStyle: BlurStyle.outer,
            )
          ],
        ),
        child: Center(child: AnimatedGlowingTrashIcon(size: box.W * 0.05)),
      ),
    );
  }
}
