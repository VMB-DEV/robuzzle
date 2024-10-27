import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/string.dart';
import 'package:robuzzle/features/level/presentation/page/map/star/widget_glowing_star.dart';
import 'package:robuzzle/features/level/presentation/page/map/widget_map_case.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/state_in_game.dart';

import '../../../domain/entities/puzzle/entity_map.dart';
import '../../../domain/entities/puzzle/entity_position.dart';
import '../../state_management/bloc/game_anim/bloc_in_game.dart';
import '../../state_management/bloc/game_anim/event_in_game.dart';
import 'ship/widget_ship.dart';

class MapWidget extends StatelessWidget {
  final InGameStateLoaded state;
  final int _noIndex = -1;

  const MapWidget({required this.state, super.key});

  VoidCallback _onMapCaseTap(BuildContext context, PositionEntity position) => () {
    context.read<InGameBloc>().add(InGameEventToggleMapCase(position: position));
  };

  @override
  Widget build(BuildContext context) {
    final currentIndex = state is InGameStateMoving ? state.actionsList.currentIndex : -1 ;
    final MapEntity map = currentIndex == _noIndex ? state.level.map : state.actionsList.currentMap;
    final ship = currentIndex == _noIndex ? state.level.map.ship : state.actionsList.currentShip;
    return LayoutBuilder(builder: (_, box) {
      final cellWidth = box.W / map.maxCol;
      final cellHeight = box.H / (state.level.map.casesNumber / map.maxCol);
      return Container(
        height: box.H,
        width: box.W,
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: map.aspectRatio,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: map.maxCol),
            itemCount: state.level.map.casesNumber,
            itemBuilder: (context, index) {
              PositionEntity pos = map.getPositionBy(linearIndex: index);
              String caseLetter = map.charAt(pos);
              bool isSelected = state.level.map.containStopMark(pos);
              return GestureDetector(
                onTap: _onMapCaseTap(context, pos),
                child: Stack(children: [
                  MapCaseWidget(
                      char: caseLetter,
                      borders: isSelected,
                      size: cellHeight,
                      key: ValueKey('${currentIndex.hashCode}')
                  ),
                  ...(caseLetter.isLowerCase) ? [const AnimatedGlowingStar()] : [],
                  ...(ship.pos == pos) ? [ AnimatedShip(rotation: ship.dir.angle)] : []
                ]),
              );
            },
          ),
        ),
      );
    });
  }
}
