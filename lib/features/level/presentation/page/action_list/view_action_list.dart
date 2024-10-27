import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/double.dart';
import 'package:robuzzle/core/extensions/list.dart';
import 'package:robuzzle/features/level/domain/entities/level/entity_actions_list_item.dart';
import 'package:robuzzle/features/level/presentation/page/action_list/widget_scroll_tracker_action_list.dart';
import 'package:robuzzle/features/level/presentation/page/page_level.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/bloc_in_game.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/state_in_game.dart';

import 'painter_action_list.dart';

class ActionListView extends StatelessWidget {
  const ActionListView({super.key});

  List<ActionListItemEntity> _sublistBy( List<ActionListItemEntity> list, int index,)
  => list.sublist( index, list.indexOrNull(index + 50)).toList();
    // ..addAll(List.generate(10, (_) => ActionListItemEntity(action: ActionEntity.noAction, actionPosition: PositionEntity.none(), map: MapEntity.empty))) ;

  @override
  Widget build(BuildContext context) => BlocConsumer<InGameBloc, InGameState>(
    listener: (context, state) {},
    builder: (context, state) {
      if (state is InGameStateLoaded) {
        return state.actionsList.list.isNotEmpty ? LayoutBuilder(
          builder: (context, box) {
            final int maxItems = box.maxWidth ~/ boxSizeStatic + 1;
            final int currentIndex = state.actionsList.currentIndex;
            final List<ActionListItemEntity> currentList = _sublistBy(state.actionsList.list, currentIndex,);
            return Padding(
              padding: const EdgeInsetsDirectional.symmetric(vertical: 2.0),
              child: Stack(
                children: [
                  ActionListDisplay( 
                    list: currentList,
                    itemsOnScreen: maxItems,
                    box: box,
                    state: state,
                  ),
                  ActionListScrollTracker(
                    list: state.actionsList.list,
                    itemSize: boxSizeStatic.toSize(),
                    box: box,
                    index: currentIndex,
                    key:ValueKey('${state.runtimeType}'),
                  ),
                ],
              ),
            );
          }
        ) : Container();
      } else { return Container(); }
    },
  );
}

class ActionListDisplay extends StatelessWidget {
  final List<ActionListItemEntity> list;
  final int itemsOnScreen;
  final BoxConstraints box;
  final InGameStateLoaded state;

  const ActionListDisplay({
    super.key,
    required this.list,
    required this.itemsOnScreen,
    required this.box,
    required this.state,
  });


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InGameBloc, InGameState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is InGameStateLoaded) {
          return SizedBox(
            height: box.H,
            width: box.W,
            child: CustomPaint(
              painter: ActionCaseListPainter( list: list, caseSize: boxSizeStatic.toInt(), ),
            ),
          );
        } else { return const SizedBox(); }
      },
    );
  }
}

