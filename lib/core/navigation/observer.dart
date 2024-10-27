import 'package:flutter/material.dart';
import 'package:robuzzle/core/log/consolColors.dart';

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printBlue('GoRouterObserver.didPush - Pushed route: ${route.settings.name}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printYellow('GoRouterObserver.didPop - Popped route: ${route.settings.name}');
  }
}
