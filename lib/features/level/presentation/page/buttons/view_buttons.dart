import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/core/widgets/BlurryContainer.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/bloc_in_game.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/event_in_game.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/state_in_game.dart';

import '../../../../../core/log/consolColors.dart';
import '../../../../settings/presentation/widget/popup_route_settings.dart';
import '../../../../settings/presentation/widget/popup_layout_settings.dart';

class ButtonsView extends StatelessWidget {
  const ButtonsView({ super.key });

  @override
  Widget build(BuildContext context) => BlocConsumer<InGameBloc, InGameState>(
    listener: (context, state) {},
    builder: (context, state) {
      int index = state is InGameStateLoaded ? state.actionsList.currentIndex : 0;
      return _layout(state, index);
    }
  );

  Widget _layout(InGameState state, int index) => LayoutBuilder(
    builder: (context, constraints) {
      final orientation = MediaQuery.orientationOf(context);
      return _blur(
        height: constraints.H,
        width: constraints.W,
        orientation: orientation,
        child: _backgroundColor(
          orientation: orientation,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buttonRewind(context, constraints, index, orientation),
              state is InGameStateOnPlay ? _buttonPause(context, constraints, orientation) : _buttonPlay(context, constraints, orientation),
              _buttonForward(context, constraints, index, orientation),
              _buttonReset(context, constraints, index, orientation),
              _buttonSettings(context, constraints, orientation),
            ],
          ),
        ),
      );
    }
  );

  BorderRadius _borderRadius(Orientation orientation) => BorderRadius.only(
    topLeft: orientation.isLandscape ? Radius.zero : const Radius.elliptical(30, 15),
    topRight: orientation.isLandscape ? const Radius.circular(15) : const Radius.elliptical(30, 15),
    bottomRight: orientation.isLandscape ? const Radius.circular(15) : Radius.zero,
  );

  Border _border(Orientation orientation) => Border(
    top: const BorderSide(color: Colors.white, width: 1),
    left: orientation.isLandscape ? BorderSide.none : const BorderSide(color: Colors.white, width: 1),
    right: const BorderSide(color: Colors.white, width: 1),
    bottom: orientation.isLandscape ? const BorderSide(color: Colors.white, width: 1) : BorderSide.none,
  );

  List<Color> get _colors => [
    const Color(0xFF997259).withOpacity(0.20),
    const Color(0xFF727259).withOpacity(0.17),
    const Color(0xFF727259).withOpacity(0.13),
    const Color(0xFF727259).withOpacity(0.21),
    const Color(0xFF727259).withOpacity(0.18),
    const Color(0xFF727259).withOpacity(0.16),
    const Color(0xFF727259).withOpacity(0.19),
  ];

  Widget _blur({
    required double height,
    required double width,
    required Orientation orientation,
    required Widget child,
  }) => BlurryContainer(
    height: height,
    width: width,
    alignment: Alignment.center,
    borderRadius: _borderRadius(orientation),
    blurSigmaX: 10,
    blurSigmaY: 10,
    child: child,
  );

  Widget _backgroundColor({required Orientation orientation, required Widget child}) => Container(
      decoration: BoxDecoration(
        border: _border(orientation),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _colors,
        ),
        borderRadius: _borderRadius(orientation),
      ),
      child: child
  );


  Widget _buttonRewind(BuildContext context, BoxConstraints constraints, int index, Orientation orientation) {
  // Widget _buttonRewind(BuildContext context, int index) {
    final rewindIcon = Icon(
      Symbols.fast_rewind_rounded,
      fill: 0.4,
      weight: 700,
      grade: 0.5,
      opticalSize: 35,
      size: orientation.isLandscape ? constraints.H * 0.65 : constraints.H * 0.80,
      // size: height * 0.8,
      color: index == 0 ? Colors.white38 : Colors.grey.shade100,
      shadows: index == 0 ? null : [ Shadow(color: Colors.grey.shade100, blurRadius: 1.5) ],
    );

    return GestureDetector(
      onTap: () { if (index != 0) context.read<InGameBloc>().add(InGameEvenIndexUpdate(newIndex: index - 1)); },
      child: rewindIcon,
    );
  }

  Widget _buttonForward(BuildContext context, BoxConstraints constraints, int index, Orientation orientation) {
  // Widget _buttonForward(BuildContext context, int index) {
    final forwardIcon = Icon(
      Symbols.fast_forward_rounded,
      fill: 0.4,
      weight: 700,
      grade: 0.5,
      opticalSize: 35,
      size: orientation.isLandscape ? constraints.H * 0.65 : constraints.maxHeight * 0.80,
      // size: height * 0.8,
      color: Colors.grey.shade100,
      shadows: index == 0 ? [] : [ Shadow(color: Colors.grey.shade100, blurRadius: 1.5) ],
    );

    return GestureDetector(
      onTap: () { context.read<InGameBloc>().add(InGameEvenIndexUpdate(newIndex: index + 1)); },
      child: forwardIcon,
    );
  }

  Widget _buttonReset(BuildContext context, BoxConstraints constraints, int index, Orientation orientation) {
  // Widget _buttonReset(BuildContext context, int index) {
    final resetIcon = Icon(
      Symbols.settings_backup_restore_rounded,
      fill: 0.4,
      weight: 700,
      grade: 0.5,
      opticalSize: 50,
      size: orientation.isLandscape ? constraints.H * 0.50 : constraints.maxHeight * 0.70,
      // size: height * 0.7,
      color: index == 0 ? Colors.white38 : Colors.grey.shade100,
      shadows: index == 0 ? null : [ Shadow(color: Colors.grey.shade100, blurRadius: 1.5) ],
    );

    return GestureDetector(
      onTap: () { if (index != 0) context.read<InGameBloc>().add(InGameEventReset()); },
      child: resetIcon,
    );
  }

  Widget _buttonPlay(BuildContext context, BoxConstraints constraints, Orientation orientation) {
  // Widget _buttonPlay(BuildContext context) {
    final playIcon = Icon(
      Symbols.play_arrow_rounded,
      fill: 0.4,
      weight: 700,
      grade: 0.5,
      opticalSize: 35,
      size: orientation.isLandscape ? constraints.H * 0.65 : constraints.maxHeight * 0.80,
      color: Colors.grey.shade100,
      shadows: [ Shadow(color: Colors.grey.shade100, blurRadius: 1.5) ],
    );

    return GestureDetector(
      onTap: () { context.read<InGameBloc>().add(InGameEventPlay()); },
      child: playIcon,
    );
  }

  Widget _buttonSettings(BuildContext context, BoxConstraints constraints, Orientation orientation) {
  // Widget _buttonSettings(BuildContext context) {
    final settingsIcon = Icon(
      Symbols.settings_rounded,
      fill: 0.15,
      weight: 600,
      opticalSize: 80,
      size: orientation.isLandscape ? constraints.H * 0.45 : constraints.maxHeight * 0.60,
      // size: height * 0.6,
      // shadows: const [ Shadow(color: Colors.black, blurRadius: 15.0) ],
      color: Colors.grey.shade100,
      shadows: [ Shadow(color: Colors.grey.shade100, blurRadius: 1.5) ],
    );

    return GestureDetector(
      onTap: () {
        showCustomSettingsPopup(context, child: const SettingsPopupLayout());
      },
      child: settingsIcon,
    );
  }

  Widget _buttonPause(BuildContext context, BoxConstraints constraints, Orientation orientation) {
  // Widget _buttonPause(BuildContext context) {
    final stopIcon = Icon(
      Symbols.pause_rounded,
      fill: 0.4,
      weight: 700,
      grade: 0.5,
      opticalSize: 50 ,
      size: constraints.maxHeight * 0.8,
      // size: height * 0.8,
      color: Colors.grey.shade100,
      shadows: const [ Shadow(color: Colors.white, blurRadius: 1.5) ],
    );

    return GestureDetector(
      onTap: () { context.read<InGameBloc>().add(InGameEventPause()); },
      child: stopIcon,
    );
  }
}
