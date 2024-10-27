import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:robuzzle/core/widgets/BlurryContainer.dart';
import 'package:robuzzle/features/puzzles_list/presentation/page/list/painter_card.dart';
import 'package:robuzzle/features/puzzles_list/presentation/page/list/painter_map_preview.dart';
import 'package:robuzzle/features/puzzles_list/presentation/state_management/bloc/bloc_puzzle_list.dart';
import 'package:robuzzle/features/puzzles_list/presentation/state_management/bloc/event_puzzle_list.dart';

import '../../../../../core/navigation/pages.dart';
import '../../../../../core/navigation/router.dart';
import '../../../domain/entities/entity_puzzle_list.dart';
import '../page_level_list.dart';

class PuzzleListElementWidget extends StatelessWidget {
  final PuzzleListEntity puzzleListElement;
  final BoxConstraints box;
  final double sizedBoxHeight;
  final double sizedBoxWidth;
  final double cardH;
  final double cardW;
  final double paddV;
  final double paddH;
  final int difficulty;
  final void Function(int, int) onTap;

  const PuzzleListElementWidget({
    required this.puzzleListElement,
    required this.sizedBoxHeight,
    required this.sizedBoxWidth,
    required this.cardH,
    required this.cardW,
    required this.paddV,
    required this.paddH,
    required this.box,
    required this.difficulty,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onTap(puzzleListElement.puzzle.id, difficulty),
      onTap: () {
        onTap(puzzleListElement.puzzle.id, difficulty);
        // router.push(Pages.level.path, extra: [puzzleListElement.puzzle.id, difficulty]);
      },
      child: _slidable(
        context: context,
        child: _paddAroundCard(
          child: _card,
        )
      )
    );
  }

  Widget _paddAroundCard({required Widget child}) => Container(
    alignment: Alignment.center,
    height: sizedBoxHeight,
    width: sizedBoxWidth,
    padding: EdgeInsetsDirectional.only(top: paddV, start: paddH, end: paddH),
    child: child,
  );

  Widget _slidable({ required BuildContext context, required Widget child}) => Slidable(
    key: ValueKey(puzzleListElement.puzzle.id),
    startActionPane: ActionPane(
      motion: const ScrollMotion(),
      children: [
        CustomSlidableAction(
          backgroundColor: Colors.transparent,
          onPressed: (_) {
            context.read<PuzzleListBloc>().add(PuzzleListEventAddFav(id: puzzleListElement.puzzle.id));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _addFavoriteIcon,
              _addFavoriteText,
            ],
          ),
        )
      ],
    ),

    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      children: [
        CustomSlidableAction(
          backgroundColor: Colors.transparent,
          onPressed: (_) {
            context.read<PuzzleListBloc>().add(PuzzleListEventRemoveFav(id: puzzleListElement.puzzle.id));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _removeFavoriteIcon,
              _removeFavoriteText,
            ],
          ),
        )
      ],
    ),
    child: child,
  );

  Widget get _card => CustomPaint(
    painter: CardPainter(finished: puzzleListElement.finished),
    child: BlurryContainer(
      height: cardH,
      width: cardW,
      alignment: Alignment.center,
      borderRadius: _cardBorderRadius,
      blurSigmaX: 6,
      blurSigmaY: 6,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _textPart(),
          _mapPart(),
        ],
      ),
    ),
  );

  Widget get _removeFavoriteText => _onSlideText('Remove from favorites', Colors.red.shade400,);
  Widget get _addFavoriteText => _onSlideText('Add To favorites', Colors.white,);

  Widget _onSlideText(String str, Color color) => Text(
    str,
    style: TextStyle(
      color: color,
      fontSize: 12,
      shadows: [
        Shadow(
          offset: const Offset(0.5, 0.5),
          blurRadius: 4.0,
          color: color,
        ),
        const Shadow(
          offset: Offset(-1, -1),
          blurRadius: 6.0,
          color: Colors.black26,
        ),
      ],
    ),
  );

  Widget get _addFavoriteIcon => Icon(
    Symbols.favorite_border_rounded,
    fill: 0,
    color: Colors.white,
    shadows: const [
      Shadow(
        offset: Offset(0.5, 0.5),
        blurRadius: 4.0,
        color: Colors.white,
      ),
      Shadow(
        offset: Offset(-1, -1),
        blurRadius: 6.0,
        color: Colors.black26,
      ),
    ],
    weight: 1000,
    opticalSize: 50,
    size: cardH * 0.20,
  );

  Widget get _removeFavoriteIcon => Stack( children: [
    Icon(
      Symbols.remove,
      fill: 0,
      color: Colors.red.shade400,
      weight: 1000,
      opticalSize: 50,
      size: cardH * 0.2,
    ),
    Icon(
      Symbols.favorite_border_rounded,
      fill: 0,
      color: Colors.red.shade400,
      shadows: [
        Shadow(
          offset: const Offset(0.5, 0.5),
          blurRadius: 4.0,
          color: Colors.red.shade400,
        ),
        const Shadow(
          offset: Offset(-1, -1),
          blurRadius: 6.0,
          color: Colors.black26,
        ),
      ],
      weight: 1000,
      opticalSize: 50,
      size: cardH * 0.20,
    ),
  ],);

  Widget _textPart() {
    return Container(
      padding: EdgeInsetsDirectional.only( start: 10, top: 10, end: 5),
      height: cardH,
      width: cardW - cardH - 10,
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text( puzzleListElement.puzzle.title, style: _titleStyle, ),
          Text( puzzleListElement.puzzle.about, style: _subtitleStyle, )
        ],
      ),
    );
  }

  Widget _mapPart() {
    final rows = puzzleListElement.puzzle.map.rows;
    final double boxSize = rows.length > rows.first.length ? cardH / rows.length : cardH / rows.first.length;
    return Container(
      alignment: Alignment.center,
      height: cardH,
      width: cardH,
      padding: const EdgeInsetsDirectional.only(end: 10),
      child: SizedBox(
        height: rows.length * boxSize,
        width: rows.first.length * boxSize,
        child: CustomPaint(
          painter: MapPreviewPainter(puzzleListElement.puzzle.map.rows),
        ),
      ),
    );
  }

  TextStyle get _titleStyle => const TextStyle(
    color: Colors.white,
    fontSize: 15,
    shadows: [ Shadow(
      offset: Offset(1.2, 1.2),
      blurRadius: 5.0,
      color: Colors.black87,
    ),],
  );

  TextStyle get _subtitleStyle => TextStyle(
    color: Colors.grey.shade700,
    fontSize: 12,
    shadows: const [
      Shadow(
        offset: Offset(1.2, 1.2),
        blurRadius: 5.0,
        color: Colors.black87,
      ),
    ],
  );

  BorderRadius get _cardBorderRadius => const BorderRadius.all( Radius.elliptical(15, 25), );
  BoxDecoration get _cardDecoration => const BoxDecoration(
    borderRadius: BorderRadius.all( Radius.elliptical(15, 25), ),
  );
}
