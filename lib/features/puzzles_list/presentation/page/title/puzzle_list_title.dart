import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/widgets/clipper_rrect_custom.dart';

import '../page_level_list.dart';

class PuzzleListTitle extends StatelessWidget {
  final BoxConstraints screen;
  final int difficulty;

  const PuzzleListTitle({required this.screen, super.key, required this.difficulty});

  @override
  Widget build(BuildContext context) {
    return _title();
  }

  Widget _title() => Stack(
    children: [
      _blurryBackground(0.10, 2),
      _blurryBackground(0.105, 1.5),
      _blurryBackground(0.11, 1),
      _blurryBackground(0.115, 0.7),
      _blurryBackground(0.12, 0.5),
      _blurryBackground(0.125, 0.35),
      _blurryBackground(0.13, 0.2),
      _blurryBackground(0.135, 0.1),
      _button(child: _text()),
    ],
  );

  TextStyle get _mainTitleStyle => TextStyle(
    color: Colors.grey.shade200,
    fontSize: 35,
    shadows: [
      Shadow(
        offset: const Offset(1.2, 1.2),
        blurRadius: 5.0,
        color: Colors.tealAccent.shade400,
      ),
      const Shadow(
        offset: Offset(-1, -1),
        blurRadius: 6.0,
        color: Colors.black54,
      ),
    ],
  );

  Widget _blurryBackground(double heightRatio, double intensity) => Container(
    width: screen.W,
    height: screen.H,
    alignment: Alignment.topCenter,
    child: ClipRRect(
      clipper: CustomFullRectClipper(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: intensity, sigmaX: intensity),
        child: Container(
          height: screen.H * heightRatio,
          width: screen.W,
        ),
      ),
    ),
  );

  Widget _button({required Widget child}) => Container(
    width: screen.W,
    height: screen.H,
    alignment: Alignment.topCenter,
    padding: const EdgeInsetsDirectional.only(top: 15),
    child: Material(
      elevation: 5,
      shadowColor: Colors.tealAccent.shade400,
      borderRadius: const BorderRadius.all( Radius.elliptical(15, 20), ),
      child: Container(
        height: screen.H * 0.08,
        width: screen.W * 0.80,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.2,
            color: Colors.teal.shade600,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blueGrey.shade800,
              Colors.blueGrey.shade700,
            ],
          ),
          borderRadius: const BorderRadius.all( Radius.elliptical(15, 20), ),
        ),
        child: child,
      ),
    ),
  );

  Widget _text() => BorderedText(
    strokeWidth: 2,
    strokeJoin: StrokeJoin.round,
    strokeColor: Colors.black,
    child: Text( 'DIFFICULTY $difficulty', style: _mainTitleStyle, ),
  );

}
