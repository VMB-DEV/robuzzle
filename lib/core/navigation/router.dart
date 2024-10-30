import 'package:go_router/go_router.dart';
import 'package:robuzzle/core/navigation/pages.dart';
import 'package:robuzzle/core/presentation/background/widget_background.dart';
import 'package:robuzzle/features/level/presentation/page/page_level.dart';
import 'package:robuzzle/features/main_menu/presentation/page/page_main.dart';
import 'package:robuzzle/uiTests.dart';
import '../../features/puzzles_list/presentation/page/page_level_list.dart';
import 'observer.dart';

final router = GoRouter(
  initialLocation: Pages.mainScreen.path,
  observers: [
    GoRouterObserver(),
  ],
  routes: [
    GoRoute(
      name: 'test',
      path: '/test',
      builder: (context, state) => uiTestWidget(),
    ),
    GoRoute(
      name: Pages.mainScreen.name,
      path: Pages.mainScreen.path,
      builder: (context, state) => const AppBackground( child: MainPage(),)
    ),
    GoRoute(
      name: Pages.level.name,
      path: Pages.level.path,
      builder: (context, state) {
        final param = state.extra != null ? state.extra as List<int> : [1,1];
        return AppBackground(child: LevelPage(id: param.first, difficulty: param.last));
      }
    ),
    GoRoute(
      name: Pages.list.name,
      path: Pages.list.path,
      // builder: (context, state) => PuzzleListPage(difficulty: state.extra as int,),
      builder: (context, state) => AppBackground(child: PuzzleListPage(difficulty: state.extra as int,))
    ),
  ],
);
