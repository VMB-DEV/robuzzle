import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/core/widgets/BlurryContainer.dart';
import 'package:robuzzle/features/puzzles_list/presentation/state_management/bloc/event_puzzle_list.dart';

import '../../../../../core/widgets/clipper_rrect_custom.dart';
import '../../state_management/bloc/bloc_puzzle_list.dart';
import '../../state_management/bloc/state_puzzle_list.dart';

class PuzzleListIndicationBar extends StatefulWidget {
  final BoxConstraints screen;
  final Orientation orientation;
  const PuzzleListIndicationBar({required this.screen, required this.orientation, super.key});

  @override
  State<PuzzleListIndicationBar> createState() => _PuzzleListIndicationBarState();
}

class _PuzzleListIndicationBarState extends State<PuzzleListIndicationBar> {
  bool favSelected = false;

  @override
  Widget build(BuildContext context) => widget.orientation.isPortrait ? _portraitBar() : _landscapeBar();

  Widget _portraitBar() => Container(
    height: widget.screen.H,
    width: widget.screen.W,
    alignment: Alignment.bottomCenter,
    padding: const EdgeInsetsDirectional.only(bottom: 15),
    child: Stack(
      children: [
        _blurryBackground(),
        _barBackground(
          child: Container(
            padding: EdgeInsetsDirectional.symmetric(horizontal: widget.screen.W * 0.07),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _menuIcon,
                _favIcon,
              ],
            )
          ),
        )
      ],
    ),
  );

  Widget _landscapeBar() => Builder(
    builder: (context) {
      return Container(
        height: widget.screen.H,
        width: widget.screen.W,
        // alignment: Alignment.centerLeft,
        alignment: Alignment.centerRight,
        padding: const EdgeInsetsDirectional.only(end: 15),
        child: Stack(
          children: [
            _blurryBackground(),
            _barBackground(
              child: Container(
                padding: EdgeInsetsDirectional.symmetric(vertical: widget.screen.H * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _menuIcon,
                    _favIcon,
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
  );

  BorderRadius get _barRadius => widget.orientation.isPortrait ? const BorderRadius.only(
    topLeft: Radius.circular(55),
    topRight: Radius.circular(55),
    bottomRight: Radius.circular(35),
    bottomLeft: Radius.circular(35),
  ) : const BorderRadius.only(
    topLeft: Radius.circular(55),
    bottomLeft: Radius.circular(55),
    topRight: Radius.circular(35),
    bottomRight: Radius.circular(35),
  ) ;

  Widget get _menuIcon => GestureDetector(
    onTap: () {
      context.read<PuzzleListBloc>().add(PuzzleListEventSelectAllList());
      setState(() => favSelected = false);
    },
    child: Icon(
      Symbols.menu_rounded,
      fill: 0.9,
      weight: 2000,
      opticalSize: 50,
      size: widget.orientation.isPortrait ? widget.screen.H * 0.04 : widget.screen.W * 0.04,
      color: favSelected ? Colors.white : Colors.orange.shade600,
      shadows: [ Shadow(color: favSelected ? Colors.white : Colors.orange.shade600, blurRadius: 2) ],
    ),
  );

  Widget get _favIcon => GestureDetector(
    onTap: () {
      context.read<PuzzleListBloc>().add(PuzzleListEventSelectFavList());
      setState(() => favSelected = true);
    },
    child: Icon(
      Symbols.favorite_border_rounded,
      fill: 0,
      color: favSelected ? Colors.orange.shade600 : Colors.white,
      shadows: [ Shadow(color: favSelected ? Colors.orange.shade600 : Colors.white, blurRadius: 2) ],
      weight: 1500,
      opticalSize: 50,
      size: widget.orientation.isPortrait ? widget.screen.H * 0.03 : widget.screen.W * 0.03,
    ),
  );

  double get barHeight => widget.orientation.isPortrait ? widget.screen.H * 0.07 : widget.screen.H * 0.8;

  double get barWidth => widget.orientation.isPortrait ? widget.screen.W * 0.80 : widget.screen.W * 0.07;

  Widget _barBackground({required Widget child}) => Container(
    height: barHeight,
    width: barWidth,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF997259).withOpacity(0.20),
          const Color(0xFF727259).withOpacity(0.17),
          const Color(0xFF727259).withOpacity(0.13),
          const Color(0xFF727259).withOpacity(0.21),
          const Color(0xFF727259).withOpacity(0.18),
          const Color(0xFF727259).withOpacity(0.16),
          const Color(0xFF727259).withOpacity(0.19),
        ],
      ),
      border: Border.all(
        width: 1,
        color: Colors.white,
      ),
      borderRadius: _barRadius,
    ),
    child: child,
  );
  _blurryBackground() => BlurryContainer(
      height: barHeight,
      width: barWidth,
      alignment: Alignment.topCenter,
      borderRadius: _barRadius,
      blurSigmaX: 4,
      blurSigmaY: 4,
      child: Container(
        height: widget.screen.H * 0.1,
        width: widget.screen.W,
      )
  );
  // _blurryBackground() => Container(
  //   height: barHeight,
  //   width: barWidth,
  //   alignment: Alignment.topCenter,
  //   decoration: BoxDecoration(
  //     borderRadius: _barRadius,
  //   ),
  //   child: ClipRRect(
  //     clipper: CustomBarClipper( borderRadius: _barRadius, ),
  //     child: BackdropFilter(
  //       filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
  //       child: Container(
  //         height: widget.screen.H * 0.10,
  //         width: widget.screen.W,
  //       ),
  //     ),
  //   ),
  // );
}
