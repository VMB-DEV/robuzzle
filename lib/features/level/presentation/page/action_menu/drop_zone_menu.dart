import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_action.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_case_color.dart';
import 'package:robuzzle/features/level/domain/entities/progress/action/entity_player_instruction.dart';

import '../../state_management/bloc/functions/bloc_functions.dart';
import '../../state_management/bloc/functions/event_functions.dart';

class DropZoneMenu extends StatefulWidget {
  final Widget child;
  final CaseColorEntity caseColor;
  const DropZoneMenu({required this.child, required this.caseColor, super.key});

  @override
  State<DropZoneMenu> createState() => _DropZoneMenuState();
}

class _DropZoneMenuState extends State<DropZoneMenu> {
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      hitTestBehavior: HitTestBehavior.translucent,
      onWillAcceptWithDetails: (details) {
        context.read<FunctionsBloc>().add(FunctionsEventMenuAboveDropZone(
          actionToMergeWith: ActionEntity(instruction: PlayerInstructionEntity.none, color: widget.caseColor),
        ));
        return true;
      },
      onLeave: (_) {
        context.read<FunctionsBloc>().add(FunctionsEventMenuLeaveDropZone());
      },
      onAcceptWithDetails: (details) {
        print('_DropZoneMenuState.build - onAcceptWithDetails');
        context.read<FunctionsBloc>().add(FunctionsEventMergeActions(
          actionTargeted: ActionEntity(instruction: PlayerInstructionEntity.none, color: widget.caseColor),
        ));
        Navigator.of(context).pop();
      },
      builder: (_, __, ___) => widget.child
    );
  }
}
