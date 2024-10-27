import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/features/settings/presentation/widget/slider_speed.dart';
import 'package:robuzzle/features/settings/presentation/widget/troll_settings.dart';
import '../../domain/entities/entity_theme_type.dart';
import '../bloc/bloc_settings.dart';
import '../bloc/event_settings.dart';
import '../bloc/state_settings.dart';

//todo : https://blog.logrocket.com/advanced-guide-flutter-switches-toggles/
class SettingsWidgetLayout extends StatelessWidget {
  const SettingsWidgetLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SettingsBloc, SettingsState, SettingsStateLoaded>(
        selector: (state) => state as SettingsStateLoaded,
        builder: (context, state) {
          return LayoutBuilder(
            builder: (context, box) {
              final List<Widget> settingsList = _settingsList(box.W, state, context);
              final Orientation orientation = MediaQuery.orientationOf(context);
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: orientation.isPortrait
                    ? _portraitLayout(context, state, box, settingsList)
                    : _landscapeLayout(context, state, box, settingsList),
              );
            },
          );
        },
    );
  }

  _portraitLayout(BuildContext ctx, SettingsStateLoaded state, BoxConstraints box, List<Widget> settingsList) => Stack(children: [
    Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _title(height: box.H * 0.1, width: box.W),
        SizedBox(
          height: box.H * 0.75,
          width: box.W,
          child: ListView.builder(
            itemCount: settingsList.length,
            itemBuilder: (context, index) {
              return settingsList[index];
            },
          ),
        ),
        _back(
          orientation: Orientation.portrait,
          height: box.H * 0.1,
          width: box.W,
          onTap: () { Navigator.of(ctx).pop(); },
        ),
      ],
      // ),
    ),
    if (state is SettingsStateTrollAnimation && state.counter == SettingsTroll.maxCount)
      Center(
        child: Gif(
          image: const AssetImage( 'assets/gif/mj.gif' ),
          duration: const Duration(seconds: 2),
          autostart: Autostart.loop,
        ),
      )
    ,
  ],);

  _landscapeLayout(BuildContext ctx, SettingsStateLoaded state, BoxConstraints box, List<Widget> settingsList) =>_troll(
    state,
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: _title(height: box.W * 0.1, width: box.H),
        ),
        SizedBox(
          height: box.W * 0.85,
          width: box.H,
          child: ListView.builder(
            itemCount: settingsList.length,
            itemBuilder: (context, index) {
              return settingsList[index];
            },
          ),
        ),
        SizedBox(
          width: box.W * 0.15,
          height: box.H,
          child: _back(
              orientation: Orientation.landscape,
              height: box.W * 0.15,
              width: box.H,
              onTap: () { Navigator.of(ctx).pop(); }),
        ),
      ],
    ),
  );

  Widget _troll(SettingsState state, Widget child) => Stack(
      children: [
        child,
        if (state is SettingsStateTrollAnimation && state.counter == SettingsTroll.maxCount)
          Center(
            child: Gif(
              image: const AssetImage( 'assets/gif/mj.gif' ),
              duration: const Duration(seconds: 2),
              autostart: Autostart.loop,
            ),
          )
        ,
      ],
  );

  List<Widget> _settingsList(double width, SettingsStateLoaded state, BuildContext context) {
    return [
      _speed(width: width, scale: state.settings.scale),
      _switch(
        title: 'Dark theme',
        subtitle: state.settings.theme.isDark
            ? 'Toggle to modify the app colors to a light theme'
            : 'Toggle to modify the app colors to a dark theme',
        width: width,
        value: state is SettingsStateTrollAnimation ? false : true,
        onChange: (dark) {
          context.read<SettingsBloc>().add(
            SettingsEventSetTheme(theme: dark ? ThemeTypeEntity.dark : ThemeTypeEntity.light),
          );

          int count = context.read<SettingsBloc>().trollCount;
          print('SettingsLayout._settingsList - ${count}');
          final snackBar = SettingsTroll(counter: count).snackBar;
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
      ),
      _switch(
        title: 'Left hand',
        subtitle: state.settings.leftHanded
            ? 'Toggle to modify the UI to the right handed'
            : 'Toggle to modify the UI to the left handed',
        width: width,
        value: state.settings.leftHanded,
        onChange: (leftHanded) => context.read<SettingsBloc>().add(
          SettingsEventSetLeftHand(leftHand: leftHanded),
        ),
      ),
      _switch(
        title: 'Animations',
        subtitle: state.settings.animations
            ? 'Toggle to remove all the app animations'
            : 'Toggle to add all the app animations   ',
        width: width,
        value: state.settings.animations,
        onChange: (animations) => context.read<SettingsBloc>().add(
          SettingsEventSetAnimations(animations: animations),
        ),
      ),
    ];
  }

  Widget _speed({required double width, required double scale}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game speed', style: _titleStyle,),
            Text('Slide to selection game animation speed', style: _subtitleStyle,),
            SpeedSlider(value: scale),
          ],
        ),
      ),
    );
  }

  Widget _switch({
    required String title,
    required String subtitle,
    required double width,
    required bool value,
    required ValueChanged<bool> onChange,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: SizedBox(
        width: width,
        child: SwitchListTile(
          title: Text( title, style: _titleStyle, ),
          subtitle: Text( subtitle, style: _subtitleStyle, ),
          value: value,
          onChanged: onChange,
          activeColor: Colors.tealAccent.shade400,
          activeTrackColor: Colors.teal.shade600,
          inactiveThumbColor: Colors.teal.shade800,
          trackOutlineColor: value
              ? WidgetStatePropertyAll(Colors.tealAccent.shade400)
              : WidgetStatePropertyAll(Colors.teal.shade600),
        ),
      ),
    );
  }

  Widget _title({ required double height, required double width}) {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.topCenter,
      child: BorderedText(
        strokeWidth: 2,
        strokeJoin: StrokeJoin.round,
        // strokeColor: Colors.teal.shade600,
        strokeColor: Colors.black,
        child: Text( 'Settings', style: _mainTitleStyle, ),
      ),
    );
  }

  Widget _back({required double height, required double width, required Orientation orientation, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              orientation.isPortrait
                  ? Symbols.keyboard_arrow_down_rounded
                  : Symbols.keyboard_arrow_right_rounded
              ,
              shadows: const [
                Shadow(
                  offset: Offset(1.2, 1.2),
                  blurRadius: 10.0,
                  color: Colors.black87,
                ),
              ],
              size: height,
            ),
          ],
        ),
      ),
    );
  }

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

  TextStyle get _titleStyle => const TextStyle(
    color: Colors.white,
    fontSize: 19,
    shadows: [
      Shadow(
          offset: Offset(1.2, 1.2),
          blurRadius: 5.0,
          color: Colors.black87
      ),
    ],
  );

  TextStyle get _subtitleStyle => TextStyle(
    color: Colors.grey.shade700,
    fontSize: 15,
    shadows: const [
      Shadow(
        offset: Offset(1.2, 1.2),
        blurRadius: 5.0,
        color: Colors.black87,
      ),
    ],
  );

}
