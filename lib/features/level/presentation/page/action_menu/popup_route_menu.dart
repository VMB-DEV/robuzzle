import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robuzzle/features/level/presentation/page/action_menu/background_menu.dart';
import 'package:robuzzle/features/level/presentation/state_management/bloc/functions/event_functions.dart';

import '../../state_management/bloc/functions/bloc_functions.dart';

Future<T?> showCustomMenuPopup<T>(BuildContext context, {required Widget child, required Offset origin}) {
  return Navigator.of(context).push(SplitBackgroundPopup(child: child, origin: origin) as Route<T>);
}

class SplitBackgroundPopup extends PopupRoute {
  final Widget child;
  final Offset origin;

  SplitBackgroundPopup({required this.child, required this.origin});

  @override
  Color get barrierColor => Colors.black54.withOpacity(0.3);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              FadeTransition(
                opacity: animation,
                child: Stack(
                  children: [
                    BackgroundMenu(
                      size: screenSize,
                      outsideChildTap: () {
                        context.read<FunctionsBloc>().add(FunctionsEventMenuCancel());
                        Navigator.of(context).pop();
                      },
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.decelerate,
                      child: Center(child: this.child,),
                    )
                    // Transform(
                    //   transform: Matrix4.identity()
                    //     ..translate(origin.dx + boxSizeStatic / 2, origin.dy + boxSizeStatic / 2)
                    //     ..scale(animation.value)
                    //     ..translate(-origin.dx, -origin.dy)
                    //   ,
                    //   // alignment: originAlignment,
                    //   child: Center(child: this.child),
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
