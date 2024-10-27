import 'package:flutter/material.dart';
import 'package:robuzzle/core/log/consolColors.dart';

class GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Log.grey('GoRouterObserver.didPush - ');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    Log.grey('GoRouterObserver.didPop - ');
  }
}
