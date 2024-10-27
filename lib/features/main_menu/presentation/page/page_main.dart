import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:robuzzle/core/extensions/Box.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/list.dart';
import 'package:robuzzle/core/extensions/map.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/core/presentation/animations/animation_type.dart';
import 'package:robuzzle/core/presentation/animations/staggered_anim.dart';
import 'package:robuzzle/features/main_menu/presentation/page/buttons/widget_button_main.dart';
import 'package:robuzzle/features/puzzles_list/presentation/state_management/bloc/bloc_puzzle_list.dart';

import '../../../../core/log/consolColors.dart';
import '../../../../core/navigation/pages.dart';
import '../../../../core/navigation/router.dart';
import '../../../../core/presentation/animations/animation_state.dart';
import '../../../puzzles_list/presentation/state_management/bloc/event_puzzle_list.dart';
import '../../../settings/presentation/widget/popup_route_settings.dart';
import '../../../settings/presentation/widget/popup_layout_settings.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  final int _widgetListLen = 9;

  late AnimationController _controller;
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemScaleTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 100);
  final List<Interval> _itemAnimIntervals = [];
  List<Interval> _itemAnimIntervalsReversed = [];
  Duration _animationDuration = const Duration(milliseconds: 0);

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
      _itemAnimIntervalsReversed = _itemAnimIntervals.reversed.toList();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, box) => _animatedWidgetBuilder(box)
      ),
    );
  }


  Widget _animatedWidgetBuilder(BoxConstraints box) {
    final orientation = MediaQuery.orientationOf(context);

    List<Widget> list = orientation.isLandscape ? [
      ..._listDifficultyButtons(orientation, box).copy.mapIndexed((i, widget)
      => animatedElement(
        forwardAnim: StaggeredAnim(i, AnimationType.fadeScale),
        reverseAnim: StaggeredAnim(i, AnimationType.slideLeft),
        child: widget,
      )),
      animatedElement(
        forwardAnim: const StaggeredAnim(7, AnimationType.fadeScale),
        reverseAnim: const StaggeredAnim(0, AnimationType.slideRight),
        child: _userButton(orientation, box),
      ),
      animatedElement(
        forwardAnim: const StaggeredAnim(6, AnimationType.fadeScale),
        reverseAnim: const StaggeredAnim(1, AnimationType.slideRight),
        child: _creatorButton(orientation, box),
      ),
      animatedElement(
        forwardAnim: const StaggeredAnim(5, AnimationType.fadeScale),
        reverseAnim: const StaggeredAnim(2, AnimationType.slideRight),
        child: _settingsButton(orientation, box),
      ),
      animatedElement(
        forwardAnim: const StaggeredAnim(4, AnimationType.fadeScale),
        reverseAnim: const StaggeredAnim(3, AnimationType.slideRight),
        child: _aboutButton(orientation, box),
      ),
    ] : [
      animatedElement(
        forwardAnim: const StaggeredAnim(0, AnimationType.fadeScale),
        reverseAnim: const StaggeredAnim(0, AnimationType.fadeScale),
        child: _userButton(orientation, box),
      ),
      ..._listDifficultyButtons(orientation, box).copy.mapIndexed((i, widget)
      => animatedElement(
        forwardAnim: StaggeredAnim(i,  i % 2 == 0 ? AnimationType.slideLeft : AnimationType.slideRight),
        reverseAnim: StaggeredAnim(i, i % 2 == 0 ? AnimationType.slideLeft : AnimationType.slideRight),
        child: widget,
      )),
      animatedElement(
        forwardAnim: const StaggeredAnim(6, AnimationType.fadeScale),
        reverseAnim: const StaggeredAnim(5, AnimationType.fadeScale),
        child: _settingsButton(orientation, box),
      ),
      animatedElement(
        forwardAnim: const StaggeredAnim(7, AnimationType.fadeScale),
        reverseAnim: const StaggeredAnim(7, AnimationType.fadeScale),
        child: _creatorButton(orientation, box),
      ),

      animatedElement(
        forwardAnim: const StaggeredAnim(7, AnimationType.fadeScale),
        reverseAnim: const StaggeredAnim(7, AnimationType.fadeScale),
        child: _aboutButton(orientation, box),
      ),
    ];

    return orientation.isLandscape
        ? _landscapeLayout(box, list)
        : _portraitLayout(box, list);
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
        AnimationStatus.dismissed => 1.0,
        AnimationStatus.completed => 1.0,
      };
      final forwardSlideRightDistance = (1.0 - animationPercent) * 150;
      final forwardSlideLeftDistance = forwardSlideRightDistance * -1;
      final reverseSlideRightDistance = (1.0 - animationPercent) * 200;
      final reverseSlideLeftDistance = reverseSlideRightDistance * -1;

      return Opacity(
        opacity: animationPercent,
        child: switch (_controller.isForwardOrCompleted) {
          true => switch (forwardAnim.type) {
            AnimationType.slideLeft => Transform.translate( offset: Offset(forwardSlideLeftDistance, 0), child: child, ),
            AnimationType.slideRight => Transform.translate( offset: Offset(forwardSlideRightDistance, 0), child: child, ),
            AnimationType.fadeScale => Transform.scale( scale: animationPercent, child: child, ),
            _ => child,
          },
          false => switch (reverseAnim.type) {
            AnimationType.slideLeft => Transform.translate( offset: Offset(reverseSlideLeftDistance, 0), child: child, ),
            AnimationType.slideRight => Transform.translate( offset: Offset(reverseSlideRightDistance, 0), child: child, ),
            AnimationType.fadeScale => Transform.scale( scale: animationPercent, child: child, ),
            _ => child,
          },
        },
      );
    },
    child: child,
  );


  _portraitLayout(BoxConstraints box, List<Widget> widgetList) => Builder( builder: (context) {
    return Column( children: [
      Container(
        // padding: const EdgeInsets.symmetric(horizontal: 10),
        height: box.H * 0.15,
        width: box.W,
        alignment: Alignment.centerRight,
        child: widgetList[0],
      ),
      SizedBox(
        height: box.H * 0.75,
        width: box.W,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgetList.sublist(1, 6),
        ),
      ),
      Container(
        height: box.H * 0.1,
        width: box.W,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // children: widgetList.sublist(6),
          children: [
            widgetList[7],
            widgetList[6],
            widgetList[8],
          ],
        ),
      ),
    ],);
  },);

  _landscapeLayout(BoxConstraints box, List<Widget> widgetList) => Builder( builder: (context) {
    return Row( children: [
      SizedBox(
        height: box.H,
        width: box.W * 0.65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgetList.sublist(0, 5)
        ),
      ),
      SizedBox(
        height: box.H,
        width: box.W * 0.35,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widgetList.sublist(5)
        ),
      )
    ],);
  },);
  
  List<Widget> _listDifficultyButtons(Orientation orientation, BoxConstraints box)
  => List.generate(5, (i) => MainButtonWidget(
    box: box,
    orientation: orientation,
    text: 'DIFFICULTY ${i + 1}',
    onTap: () {
      _controller.reverse();
      Future.delayed(_staggerTime * (_widgetListLen )).then((_) {
        context.read<PuzzleListBloc>().add(PuzzleListEventLoad(difficulty: i + 1));
        router.push(Pages.list.path, extra: i + 1);
      }).then((_) => Future.delayed(_staggerTime).then((_)=>_controller.backToNorm()));
    },
    typeSize: MainButtonWidgetTypeSize.large,
  ));

  Widget _userButton(Orientation orientation, BoxConstraints box)
  => MainButtonWidget(
    typeSize: MainButtonWidgetTypeSize.normal,
    orientation: orientation,
    box: box,
    text: 'User',
    onTap: () {},
    enable: false,
  );

  Widget _aboutButton(Orientation orientation, BoxConstraints box)
  => MainButtonWidget(
    typeSize: MainButtonWidgetTypeSize.normal,
    box: box,
    orientation: orientation,
    text: 'About us',
    enable: false,
  );

  Widget _creatorButton(Orientation orientation, BoxConstraints box)
  => MainButtonWidget(
    typeSize: MainButtonWidgetTypeSize.normal,
    box: box,
    orientation: orientation,
    text: 'Creator',
    enable: false,
  );

  Widget _settingsButton(Orientation orientation, BoxConstraints box)
  => Builder( builder: (context) => MainButtonWidget(
    box: box,
    orientation: orientation,
    // small: true,
    typeSize: MainButtonWidgetTypeSize.small,
    text: 'S',
    onTap: () => showCustomSettingsPopup(context, child: const SettingsPopupLayout()),
    icon: const Icon(
      Symbols.settings_rounded,
      fill: 0.15,
      weight: 600,
      opticalSize: 80,
      shadows: [ Shadow(color: Colors.black, blurRadius: 15.0) ],
  ),),);
}
