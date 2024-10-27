import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/features/level/presentation/page/map/widget_map.dart';
import 'package:robuzzle/features/level/presentation/page/map/win/widget_win.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/state_in_game.dart';

import '../../../../../core/widgets/UnknownStateWidget.dart';
import '../../state_management/bloc/game_anim/bloc_in_game.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InGameBloc, InGameState>(
      listener: (context, state) {},
      builder: (context, state) {
         if (state is InGameStateLoaded) {
          return Stack(
            children: [
              MapWidget(state: state),
              if (state is InGameStateWin) const WinWidget()
            ],
          );
        } else if (state is InGameStateError) {
          return UnknownStateWidget(stateName: state.runtimeType.toString(), msg: state.message,);
        } else {
          return UnknownStateWidget(stateName: state.runtimeType.toString());
        }
      },
    );
  }
}

