import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/core/widgets/BlurryContainer.dart';
import 'package:robuzzle/core/widgets/LoadingWidget.dart';
import 'package:robuzzle/core/widgets/UnknownStateWidget.dart';
import 'package:robuzzle/features/level/presentation/page/functions/painter_functions.dart';
import 'package:robuzzle/features/level/presentation/page/functions/widgetTrash.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/bloc_in_game.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/state_in_game.dart';
import 'package:robuzzle/features/settings/presentation/bloc/bloc_settings.dart';
import 'package:robuzzle/features/settings/presentation/bloc/state_settings.dart';

import '../../../../../core/widgets/ErrorView.dart';
import '../../../domain/entities/progress/entity_functions.dart';
import '../../../domain/entities/puzzle/entity_position.dart';
import '../../state_management/bloc/functions/bloc_functions.dart';
import '../../state_management/bloc/functions/state_functions.dart';
import '../page_level.dart';
import 'drag_and_drop_functions.dart';


class FunctionsView extends StatelessWidget {
  const FunctionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsBloc, SettingsState, SettingsStateLoaded>(
      selector: (settingsState) => settingsState as SettingsStateLoaded,
      builder: (context, settingsState) {
        return BlocBuilder<FunctionsBloc, FunctionsState>(
          builder: (context, functionState) {
            return BlocBuilder<InGameBloc, InGameState>(
              builder: (context, inGameState) {
                return _buildView(
                  context,
                  functionState,
                  inGameState,
                  settingsState.settings.leftHanded,
                );
              },
            );
          },
        );
      }
    );
  }

  Widget _buildView(BuildContext context, FunctionsState functionState, InGameState inGameState, bool leftHanded) {
    if (functionState is FunctionsStateLoading || inGameState is InGameStateLoading) { return LoadingWidget('Loading...'); }
    if (functionState is FunctionsStateError) { return ErrorView(functionState.message); }
    if (inGameState is InGameStateError) { return ErrorView(inGameState.message); }
    if (functionState is FunctionsStateLoaded && inGameState is InGameStateLoaded) {
      return LayoutBuilder(
        builder: (context, box) {
          return BlurryContainer(
            height: box.H,
            width: box.W,
            alignment: Alignment.center,
            borderRadius: BorderRadius.zero,
            blurSigmaX: 4,
            blurSigmaY: 4,
            color: Colors.transparent,
            child: Stack(
              children: [
                functionState.functions.compact
                  ? _compactLayout(box, inGameState, functionState, leftHanded)
                  : _normalLayout(box, inGameState, functionState, leftHanded),
                if (functionState is FunctionsStateDraggingActionFunction)
                  ActionCaseTrash(box),
              ],
            ),
          );
        },
      );
    }
    return UnknownStateWidget(stateName: '${functionState.toString()} + ${inGameState.toString()}');
  }

  Widget _normalLayout(
      BoxConstraints constraints,
      InGameStateLoaded inGameState,
      FunctionsStateLoaded functionState,
      bool leftHanded,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildWraps( constraints, inGameState, functionState, leftHanded),
      ),
    );
  }

  Widget _compactLayout(BoxConstraints constraints, InGameStateLoaded inGameState, FunctionsStateLoaded functionState, bool leftHanded,) {
    return LayoutBuilder(
      builder: (context, box) {
        final isPortrait = MediaQuery.orientationOf(context).isPortrait;
        return Row(
          mainAxisAlignment: isPortrait ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            SizedBox(
              height: box.H,
              width: box.W * 0.45,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildWrap( 0, constraints, inGameState, functionState, portrait: isPortrait, leftHanded),
                  _buildWrap( 1, constraints, inGameState, functionState, portrait: isPortrait, leftHanded),
                  _buildWrap( 2, constraints, inGameState, functionState, portrait: isPortrait, leftHanded),
                ],
              ),
            ),
            SizedBox(
              height: box.H,
              width: box.W * 0.45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildWrap( 3, constraints, inGameState, functionState, portrait: isPortrait, leftHanded),
                  _buildWrap( 4, constraints, inGameState, functionState, portrait: isPortrait, leftHanded),
                ],
              ),
            ),
          ],
        );
      }
    );
  }

  List<Widget> _buildWraps(BoxConstraints constraints, InGameStateLoaded inGameState, FunctionsStateLoaded functionState, bool leftHanded) {
    return List.generate(functionState.functions.values.nonNulls.length, (functionNumber) {
      return _buildWrap( functionNumber, constraints, inGameState, functionState, leftHanded);

    });
  }

  Widget _buildWrap(
      int functionNumber,
      BoxConstraints constraints,
      InGameStateLoaded inGameState,
      FunctionsStateLoaded functionState,
      bool leftHanded,
      {bool portrait = false}
  ) {
    final PositionEntity selectionActionPosition = functionState is FunctionsStateMenuPopup ? functionState.actionPositionStored : PositionEntity.none();
    final FunctionsEntity functions = functionState.functions;
    final PositionEntity currentActionPosition = inGameState.actionsList.currentActionPosition;
    // final maxItemPerRow = functionState.functions.compact ? compactRowEndAt : rowEndAt;
    final maxItemPerRow = functionState.functions.compact
        ? ( portrait ? compactRowEndPortrait : compactRowEndLandscape)
        : rowEndAt;
    final function = functions.values[functionNumber];
    final functionSize = function.length;

    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 30, bottom: 10, top: 10, end: 10),
      child: IntrinsicWidth(
        child: RepaintBoundary(
          child: CustomPaint(
            painter: FunctionBackgroundPainter(
              functionNumber: functionNumber,
              totalItems: functionSize,
              maxItemPerRow: maxItemPerRow,
            ),
            child: SizedBox(
              width: maxItemPerRow > functionSize ? boxSizeStatic * functionSize : boxSizeStatic * maxItemPerRow,
              child: Wrap(
                direction: Axis.horizontal,
                children: List.generate(functionSize, (col) {
                  // final action = functions.values[functionNumber][col];
                  final action = function[col];
                  final position = PositionEntity(row: functionNumber, col: col);
                  return FunctionActionCaseDragAndDrop(
                    key: ValueKey('${action.hashCode}_${functionNumber}_${col}_${currentActionPosition}_$selectionActionPosition'),
                    action: action,
                    position: position,
                    borders: position == currentActionPosition || position == selectionActionPosition,
                    darkFilter: position == selectionActionPosition,
                    leftHanded: leftHanded,
                    draggable: (functionState is FunctionsStateDraggingActionFunction) ? functionState.actionPositionStored == position : (functionState is! FunctionsStateDraggingActionFunction),
                  );
                },),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
