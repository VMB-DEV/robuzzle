import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/orientation.dart';
import 'package:robuzzle/core/widgets/slide_detector.dart';
import 'layout_widget_settings.dart';

class SettingsPopupLayout extends StatelessWidget {
  const SettingsPopupLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);

    final child = SlideDetector(
      slideRight: () { Navigator.of(context).pop(); },
      child: const SettingsWidgetLayout(),
    );

    return orientation.isPortrait ? _portraitPopup(child) : _landscapePopup(child);
  }

  _landscapePopup(Widget child) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, box) {
        final shadowColor = Colors.tealAccent.shade400;
        final borderColor = Colors.teal.shade600;
        final borderSide = BorderSide(color: borderColor, style: BorderStyle.solid, width: 2);
        return Container(
          // alignment: Alignment.centerRight,
          height: box.H,
          width: box.W * 0.65,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueGrey.shade800,
                Colors.blueGrey.shade900,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: -2,
                blurRadius: 20,
                offset: const Offset(0, 0),
              )
            ],
            border: Border( top: borderSide, bottom: borderSide, left: borderSide, ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.elliptical(20, 30),
              bottomLeft: Radius.elliptical(20, 30),
            ),
          ),
          child: child
        );
      }),
    );
  }
  _portraitPopup(Widget child) {
    final shadowColor = Colors.tealAccent.shade400;
    final borderColor = Colors.teal.shade600;
    final borderSide = BorderSide( color: borderColor, style: BorderStyle.solid, width: 2, );
    return SafeArea(
      child: LayoutBuilder(builder: (context, box) {
        return Container(
          height: box.H * 0.85,
          width: box.W,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blueGrey.shade800,
                Colors.blueGrey.shade900,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                spreadRadius: -2,
                blurRadius: 20,
                offset: const Offset(0, 0),
              )
            ],
            border: Border(
              top: borderSide,
              left: borderSide,
              right: borderSide,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.elliptical(20, 30),
              topRight: Radius.elliptical(20, 30),
            ),
          ),
          child: child,
        );
      }),
    );
  }
}
