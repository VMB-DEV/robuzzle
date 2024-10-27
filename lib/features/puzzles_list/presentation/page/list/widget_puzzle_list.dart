import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/list.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/features/puzzles_list/domain/entities/entity_puzzle_list.dart';
import 'package:robuzzle/features/puzzles_list/presentation/page/list/widget_element_puzzle_list.dart';

import '../../../../../core/log/consolColors.dart';
import '../../../../../core/widgets/UnknownStateWidget.dart';
import '../../state_management/bloc/bloc_puzzle_list.dart';
import '../../state_management/bloc/state_puzzle_list.dart';

class PuzzleListCardsWidget extends StatelessWidget {
  final Orientation orientation;
  final void Function(int, int) onTap;

  const PuzzleListCardsWidget({super.key, required this.orientation, required this.onTap});

  @override
  Widget build(BuildContext context) => BlocConsumer<PuzzleListBloc, PuzzleListState>(
    listener: (context, state) {},
    builder: (context, state) {
      switch (state) {
        case PuzzleListStateLoading(): return UnknownStateWidget(stateName: state.runtimeType.toString());
        case PuzzleListStateStateError(): return UnknownStateWidget(stateName: state.runtimeType.toString(), msg: state.message,);
        case PuzzleListStateLoaded(): return LayoutBuilder( builder: (context, box) {
          final orientation = MediaQuery.orientationOf(context);
          final double paddH = orientation.isPortrait ? box.W * 0.05 : box.W * 0.12;
          final double paddV = box.H * 0.02;
          final int numberOfElementOnScreen = orientation.isPortrait ? 6 : 4;
          final double sizedBoxHeight = box.H / numberOfElementOnScreen;
          final double sizedBoxWidth = box.W;
          final double cardHeight = sizedBoxHeight - paddV;
          final double cardWidth = sizedBoxWidth - 2 * paddH;
          List<PuzzleListEntity> list = switch (state) {
            PuzzleListStateLoadedAll() => state.list.copy,
            PuzzleListStateLoadedFav() => state.favorites.copy,
          };
          if (list.isNotEmpty && orientation.isLandscape) list = list.sublist(1);
          return SizedBox(
            height: box.H,
            width: box.W,
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                if (orientation.isPortrait && index == 0) {
                  return SizedBox(
                    height: sizedBoxHeight,
                    width: sizedBoxWidth,
                  );
                } else {
                  return PuzzleListElementWidget(
                    puzzleListElement: list[index],
                    sizedBoxHeight: sizedBoxHeight,
                    sizedBoxWidth: sizedBoxWidth,
                    cardH: cardHeight,
                    cardW: cardWidth,
                    paddH: paddH,
                    paddV: paddV,
                    box: box,
                    difficulty: state.difficulty,
                    onTap: onTap,
                  );
                }
              },
            ),
          );
        });
      }
    },
  );
}
