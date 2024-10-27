import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/Box.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/features/puzzles_list/presentation/page/title/puzzle_list_title.dart';
import 'package:robuzzle/features/puzzles_list/presentation/state_management/bloc/event_puzzle_list.dart';
import 'package:robuzzle/features/puzzles_list/presentation/state_management/bloc/state_puzzle_list.dart';
import '../../../../core/log/consolColors.dart';
import '../../../../core/navigation/pages.dart';
import '../../../../core/navigation/router.dart';
import '../../../../core/presentation/animations/animation_type.dart';
import '../../../../core/presentation/animations/staggered_anim.dart';
import '../../../level/presentation/state_management/bloc/level/bloc_level.dart';
import '../../../level/presentation/state_management/bloc/level/event_level.dart';
import '../state_management/bloc/bloc_puzzle_list.dart';
import 'bar/puzzle_list_indication_bar.dart';
import 'list/widget_puzzle_list.dart';

class PuzzleListPage extends StatelessWidget {
  final int difficulty;
  const PuzzleListPage({required this.difficulty, super.key});

  Widget _loadPuzzleListDisplayLayout(BuildContext context) {
    context.read<PuzzleListBloc>().add(PuzzleListEventLoad(difficulty: difficulty));
    return PuzzleListLayout(difficulty: difficulty,);

  }

  @override
  Widget build(BuildContext context) => BlocConsumer<PuzzleListBloc, PuzzleListState>(
    listener: (context, state) {},
    builder: (context, state) {
      switch (state) {
        case PuzzleListStateLoading(): return _loadPuzzleListDisplayLayout(context);
        case PuzzleListStateStateError(): return ErrorWidget(state.message);
        case PuzzleListStateLoaded(): {
          if (state.difficulty == difficulty) {
            return PuzzleListLayout(difficulty: difficulty, list: true,);
          } else {
            return _loadPuzzleListDisplayLayout(context);
          }
        }
      }
    },
  );
}

class PuzzleListLayout extends StatefulWidget {
  final int difficulty;
  final bool list;


  const PuzzleListLayout({
    required this.difficulty,
    this.list = false,
    super.key
  });

  @override
  State<PuzzleListLayout> createState() => _PuzzleListLayoutState();
}

class _PuzzleListLayoutState extends State<PuzzleListLayout> with SingleTickerProviderStateMixin {
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemScaleTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 200);
  static final List<Interval> _itemAnimIntervals = [];
  static final List<Interval> _itemAnimIntervalsReversed = [];
  Duration _animationDuration = const Duration(milliseconds: 0);
  final _widgetListLen = 3;
  late AnimationController _controller;

  void _createAnimationIntervals() {
    for (var i = 0; i < _widgetListLen; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemScaleTime;
      _itemAnimIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
      _itemAnimIntervalsReversed.addAll(_itemAnimIntervals.reversed);
      // _itemAnimIntervalsReversed = _itemAnimIntervals.reversed.toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _animationDuration = _initialDelayTime + (_staggerTime * (_widgetListLen + 2));
    _createAnimationIntervals();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  Widget _animatedWidgetBuilder(BoxConstraints box) {
    final orientation = MediaQuery.orientationOf(context);
    List<Widget> list = orientation.isPortrait ? [
      widget.list ? animatedElement(
        forwardAnim: const StaggeredAnim(1, AnimationType.slideTop),
        reverseAnim: const StaggeredAnim(1, AnimationType.slideTop),
        child: PuzzleListCardsWidget(orientation: Orientation.portrait, onTap: onCardTap,),
      ) : Container(),
      animatedElement(
        forwardAnim: const StaggeredAnim(0, AnimationType.slideTop),
        reverseAnim: const StaggeredAnim(0, AnimationType.slideTop),
        child: PuzzleListTitle(screen: box, difficulty: widget.difficulty),
      ),
      animatedElement(
        forwardAnim: const StaggeredAnim(2, AnimationType.slideBottom),
        reverseAnim: const StaggeredAnim(2, AnimationType.slideBottom),
        child: PuzzleListIndicationBar(screen: box, orientation: Orientation.portrait,)
      ),
    ] : [
      widget.list ? animatedElement(
        forwardAnim: const StaggeredAnim(1, AnimationType.slideTop),
        reverseAnim: const StaggeredAnim(1, AnimationType.slideTop),
        // child: const PuzzleListCardsWidget(orientation: Orientation.portrait,),
        child: PuzzleListCardsWidget(orientation: Orientation.portrait, onTap: onCardTap,),
      ) : Container(),
      animatedElement(
          forwardAnim: const StaggeredAnim(0, AnimationType.slideRight),
          reverseAnim: const StaggeredAnim(0, AnimationType.slideRight),
          child: PuzzleListIndicationBar(screen: box, orientation: Orientation.landscape,)
      ),
    ];

    return Stack(children: list);
  }

  Widget animatedElement({
    required StaggeredAnim forwardAnim,
    required StaggeredAnim reverseAnim,
    required Widget child
  }) => AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {

      final double animationPercent = switch (_controller.status) {
        AnimationStatus.forward => Curves.easeOut.transform( _itemAnimIntervals[forwardAnim.index].transform(_controller.value)),
        AnimationStatus.reverse => Curves.easeOut.transform( _itemAnimIntervalsReversed[reverseAnim.index].transform(_controller.value)),
        AnimationStatus.completed => 1.0,
        AnimationStatus.dismissed => 0.0,
      };
      final forwardSlideTopDistance = (1.0 - animationPercent) * -150;
      final forwardSlideBotDistance = forwardSlideTopDistance * -1;
      final forwardSlideRightDistance = (1.0 - animationPercent) * 150;
      final reverseSlideRightDistance = (1.0 - animationPercent) * 150;

      return Opacity(
        opacity: animationPercent,
        child: switch (_controller.isForwardOrCompleted) {
          true => switch (forwardAnim.type) {
            AnimationType.slideRight => Transform.translate( offset: Offset(forwardSlideRightDistance, 0), child: child, ),
            AnimationType.slideTop => Transform.translate( offset: Offset(0, forwardSlideTopDistance), child: child, ),
            AnimationType.slideBottom => Transform.translate( offset: Offset(0, forwardSlideBotDistance), child: child, ),
            AnimationType.fadeScale => Transform.scale( scale: animationPercent, child: child, ),
            _ => child,
          },
          false => switch (reverseAnim.type) {
            AnimationType.slideRight => Transform.translate( offset: Offset(reverseSlideRightDistance, 0), child: child, ),
            AnimationType.slideTop => Transform.translate( offset: Offset(0, forwardSlideTopDistance), child: child, ),
            AnimationType.fadeScale => Transform.scale( scale: animationPercent, child: child, ),
            _ => child,
          },
        },
      );
    },
    child: child,
  );

  // final void Function(int, int) callback() {}
  void onCardTap(int id, int diff) {
    _controller.reverse();
    // Future.delayed(_itemScaleTime * (_widgetListLen)).then((_) {
    Future.delayed(_animationDuration).then((_) {
      // context.read<PuzzleListBloc>().add(PuzzleListEventLoad(difficulty: i + 1));
      context.read<LevelBloc>().add(LevelEventLoadLevelByID(id, diff));
      router.push(Pages.level.path, extra: [id, diff]);
    }).then((_) => Future.delayed(_staggerTime).then((_)=>_controller.backToNorm()));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
          builder: (context, box) => _animatedWidgetBuilder(box)
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) => LayoutBuilder(builder: (_, screen) {
  //   final orientation = MediaQuery.orientationOf(context);
  //   return orientation.isPortrait ? _portrait(screen) : _landscape(screen);
  // });

  // Widget _portrait(BoxConstraints screen) => Stack(
  //   children: [
  //     widget.list ? const PuzzleListCardsWidget(orientation: Orientation.portrait,) : const Center(child: LoadingWidget('Loading List')),
  //     PuzzleListTitle(screen: screen, difficulty: widget.difficulty),
  //     PuzzleListIndicationBar(screen: screen, orientation: Orientation.portrait,),
  //   ],
  // );
  //
  // Widget _landscape(BoxConstraints screen) => Stack(
  //   children: [
  //     widget.list ? const PuzzleListCardsWidget(orientation: Orientation.landscape,) : const Center(child: LoadingWidget('Loading List')),
  //     PuzzleListIndicationBar(screen: screen, orientation: Orientation.landscape,),
  //   ],
  // );
}

