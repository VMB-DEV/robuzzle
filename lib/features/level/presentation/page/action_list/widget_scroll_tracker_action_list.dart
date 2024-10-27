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
  // double _scrollOffset = 0.0;

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
    // setState(() => _scrollOffset = _scrollController.offset );
    int newIndex = (_scrollController.offset / widget.itemSize.width).round();
    if (newIndex != widget.index) {
      widget.index = newIndex;
      context.read<InGameBloc>().add(InGameEvenIndexUpdate( newIndex: newIndex, ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.box.H,
      width: widget.box.W,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        // itemCount: widget.list.length + 1 + (widget.box.maxWidth/ widget.itemSize.width).toInt(),
        itemCount: widget.list.length + (widget.box.maxWidth/ widget.itemSize.width).toInt(),
        itemExtent: widget.itemSize.width,
        itemBuilder: (context, index) => SizedBox(width: widget.itemSize.width, height: widget.itemSize.height,),
      ),
    );
  }
}
