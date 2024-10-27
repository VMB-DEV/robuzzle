import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/orientation.dart';

Future<T?> showCustomSettingsPopup<T>(BuildContext context, {required Widget child}) {
  return Navigator.of(context).push( SettingsPopupRoute(child: child) as Route<T> );
}

class SettingsPopupRoute extends PopupRoute {
  final Widget child;

  SettingsPopupRoute({
    required this.child,
  });

  @override
  Color get barrierColor => Colors.black54.withOpacity(0.3);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final Orientation orientation = MediaQuery.orientationOf(context);

    return SlideTransition(
      position: Tween<Offset>(
        begin: orientation.isPortrait ? const Offset(0.0, 1.0) : const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      )),
      child: Container(
        alignment: orientation.isPortrait ? Alignment.bottomCenter : Alignment.centerRight,
        child: child,
      ),
    );
  }
}
