import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/config/themes/themes.dart';
import 'package:robuzzle/core/log/consolColors.dart';
import 'package:robuzzle/core/navigation/router.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/game_anim/bloc_in_game.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/level/bloc_level.dart';
import 'package:robuzzle/features/puzzles_list/presentation/state_management/bloc/bloc_puzzle_list.dart';
import 'core/data/hive/hiver.dart';
import 'core/di/injection.dart' as di;
import 'features/level/presentation/state_management/bloc/functions/bloc_functions.dart';
import 'features/settings/domain/entities/entity_theme_type.dart';
import 'features/settings/presentation/bloc/bloc_settings.dart';
import 'features/settings/presentation/bloc/event_settings.dart';
import 'features/settings/presentation/bloc/state_settings.dart';

Future<void> main() async {
  await Hiver().init();
  await di.init();

  final SettingsBloc settingsBloc = di.getIt<SettingsBloc>();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsBloc>(create: (BuildContext context) => settingsBloc..add(SettingsEventGet())),
        BlocProvider(create: (ctx) => FunctionsBloc()),
        BlocProvider(create: (ctx) => InGameBloc(settingsRepo: di.getIt())),
        BlocProvider<LevelBloc>(
          create: (BuildContext context) => LevelBloc(
            getLevelUseCase: di.getIt(),
            setProgressUseCase: di.getIt(),
            functionsBloc: context.read<FunctionsBloc>(),
            inGameBloc: context.read<InGameBloc>(),
            setWinUseCase: di.getIt(),
          ),
        ),
        BlocProvider<PuzzleListBloc>(
          create: (BuildContext context) => PuzzleListBloc(
            getPuzzleIdSetUseCase: di.getIt(),
            getPuzzleSetUseCase: di.getIt(),
            getPuzzleFinishedIdSetUseCase: di.getIt(),
            getPuzzleFavIdSetUseCase: di.getIt(),
            setPuzzleFavIdSetUseCase: di.getIt(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

//TODO: STRING hard coded
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<SettingsBloc, SettingsState>(builder: (context, settingState) {
      Log.yellow('MyApp.build');
      return MaterialApp.router(
        debugShowMaterialGrid: false,
        debugShowCheckedModeBanner: false,
        theme: (settingState is SettingsStateLoaded && settingState.settings.theme == ThemeTypeEntity.light)
            ? lightTheme
            : darkTheme,
        routerConfig: router,
        // router
      );
    });
  }
}
