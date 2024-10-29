import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/constraints.dart';

import '../../../domain/entities/level/entity_actions_list_item.dart';
import '../../state_management/bloc/game_anim/bloc_in_game.dart';
import '../../state_management/bloc/game_anim/event_in_game.dart';

class ActionListScrollTracker extends StatefulWidget {
  final List<ActionListItemEntity> list;
  final Size itemSize;
  final BoxConstraints box;
  int index;

  ActionListScrollTracker({
    required this.list,
    required this.itemSize,
    required this.box,
    required this.index,
    super.key
  });

  @override
  _ActionListScrollTrackerState createState() => _ActionListScrollTrackerState();
}

class _ActionListScrollTrackerState extends State<ActionListScrollTracker> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController( initialScrollOffset: widget.index * widget.itemSize.width );
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    int newIndex = (_scrollController.offset / widget.itemSize.width).round();
    if (newIndex != widget.index) {
      widget.index = newIndex;
      context.read<InGameBloc>().add(InGameEvenIndexUpdate( newIndex: newIndex, onPause: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.box.H,
      width: widget.box.W,
      child: Listener(
        onPointerSignal: (PointerSignalEvent event) {
          if (event is PointerScrollEvent) {
            final newOffset = _scrollController.offset + event.scrollDelta.dy ; // Adjust scroll speed multiplier as needed
            _scrollController.animateTo(
              newOffset.clamp(
                _scrollController.position.minScrollExtent,
                _scrollController.position.maxScrollExtent,
              ),
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOutCubic,
            );
          }
        },
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          itemCount: widget.list.length + (widget.box.maxWidth/ widget.itemSize.width).toInt(),
          itemExtent: widget.itemSize.width,
          itemBuilder: (context, index) => SizedBox(width: widget.itemSize.width, height: widget.itemSize.height,),
        ),
      ),
    );
  }
}
