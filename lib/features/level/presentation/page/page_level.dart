import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/core/log/consolColors.dart';
import 'package:robuzzle/core/widgets/LoadingWidget.dart';
import 'package:robuzzle/features/level/presentation/page/action_list/view_action_list.dart';
import 'package:robuzzle/features/level/presentation/page/title/widget_level_title.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/level/bloc_level.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/level/state_level.dart';
import 'package:robuzzle/features/settings/presentation/bloc/bloc_settings.dart';
import 'package:robuzzle/features/settings/presentation/bloc/state_settings.dart';
import '../state_management/bloc/level/event_level.dart';
import 'buttons/view_buttons.dart';
import 'functions/widget_functions.dart';
import 'map/view_map.dart';

// //TODO: INT hard coded
const int compactRowEndPortrait = 4;
const int compactRowEndLandscape = 5;
const int rowEndAt = 6;
const double boxSizeStatic = 33;
const Offset draggableOffset = Offset(-25, -30);

class LevelPage extends StatelessWidget {
  final int id;
  final int difficulty;
  const LevelPage({required this.id, required this.difficulty, super.key});

  Widget _loadLevelAndDisplayLayout(BuildContext context) {
    context.read<LevelBloc>().add(LevelEventLoadLevelByID(id, difficulty));
    return const LevelLayout();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<LevelBloc, LevelState>(
    listener: (context, state) {},
    builder: (context, state) {
      switch (state) {
        case LevelStateError():
          return ErrorWidget(state.message);
        case LevelStateLoading():
          return _loadLevelAndDisplayLayout(context);
        case LevelStateLoaded(): {
          if ( state.level.id == id) {
            return LevelLayout(
              titleWidget: LevelTitleWidget(level: state.level),
              mapView: const MapView(),
              functionView: const FunctionsView(),
              actionListView: const ActionListView(),
            );
          } else {
            return _loadLevelAndDisplayLayout(context);
          }
        }
      }
    },
  );
}

class LevelLayout extends StatelessWidget {
  final Widget mapView;
  final Widget functionView;
  final Widget actionListView;
  final Widget titleWidget;
  final bool isFinished;

  const LevelLayout({
    this.titleWidget = const Text("Level"),
    this.mapView = const LoadingWidget('Loading Map'),
    this.actionListView = const SizedBox(),
    this.functionView = const LoadingWidget('Loading Functions'),
    this.isFinished = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
    final orientation = MediaQuery.orientationOf(context);
    return BlocSelector<SettingsBloc, SettingsState, SettingsStateLoaded>(
      selector: (settingsState) { return settingsState as SettingsStateLoaded; },
      builder: (context, settingsState) {
        return orientation.isLandscape
            ? _landscape(constraints, settingsState.settings.leftHanded)
            : _portrait(constraints);
      },
    );
  },);

  Widget _landscape(BoxConstraints box, bool leftHanded) {
    final Widget leftPart = SizedBox(
      height: box.H,
      width: box.W * 0.4,
      child: LayoutBuilder(
        builder: (_, leftPart) {
          return Column(
            children: [
              _titleView(
                height: leftPart.H * 0.1,
                width: leftPart.W,
              ),
              _mapView(
                height: leftPart.H * 0.8,
                width: leftPart.W,
              ),
              _buttonsView(
                height: leftPart.H * 0.1,
                width: leftPart.W,
                orientation: Orientation.landscape,
              ),
            ],
          );
        },
      ),
    );
    final Widget rightPart = SizedBox(
      height: box.H,
      width: box.W * 0.6,
      child: LayoutBuilder(
          builder: (_, rightPart) {
            return Column(
              children: [
                _actionListView(
                  height: rightPart.H * 0.1,
                  width: rightPart.W,
                ),
                _functionsView(
                  height: rightPart.H * 0.9,
                  width: rightPart.W,
                ),
              ],
            );
          }
      ),
    );
    return Row( children: leftHanded ? [rightPart, leftPart] : [leftPart, rightPart] );
  }

  Widget _portrait(BoxConstraints box) => Column( children: <Widget>[
    _titleView(
      height: box.H * 0.05,
      width: box.W,
    ),
    _mapView(
      height: box.H * 0.35,
      width: box.W,
    ),
    _actionListView(
      height: box.H * 0.07,
      width: box.W,
    ),
    _functionsView(
      height: box.H * 0.47,
      width: box.W,
    ),
    _buttonsView(
      height: box.H * 0.06,
      width: box.W,
      orientation: Orientation.portrait,
    ),
  ],);

  _titleView({required double height, required double width, })
  => Container(
    height: height,
    width: width,
    color: Colors.black12,
    child: titleWidget,
  );

  _mapView({required double height, required double width})
  => Container(
    height: height,
    width: width,
    // color: Colors.blueGrey.shade800,
    child: mapView,
  );

  _actionListView({required double height, required double width, })
  => Container(
    height: height,
    width: width,
    color: Colors.black12,
    child: actionListView,
  );

  _functionsView({required double height, required double width, })
  => Container(
    // color: Colors.blueGrey.shade800,
    child: Container(
      height: height,
      width: width,
      child: functionView,
    ),
  );

  _buttonsView({required double height, required double width, required Orientation orientation })
  // => ButtonsView(height: height, width: width, orientation: orientation);
  => SizedBox( height: height, width: width, child: const ButtonsView(), );

}

