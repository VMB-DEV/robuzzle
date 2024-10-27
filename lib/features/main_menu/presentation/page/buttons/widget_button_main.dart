import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/extensions/orientation.dart';

enum MainButtonWidgetTypeSize {
  large,
  normal,
  small
}

class MainButtonWidget extends StatelessWidget {
  final BoxConstraints box;
  final Orientation orientation;
  final String text;
  final GestureTapCallback? onTap;
  final MainButtonWidgetTypeSize typeSize;
  final bool? verticalPadding;
  final Icon? icon;
  final bool enable;

  const MainButtonWidget({
    required this.box,
    this.orientation = Orientation.portrait,
    required this.text,
    required this.typeSize,
    this.onTap,
    this.verticalPadding,
    this.icon,
    this.enable = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final shadowColor = Colors.tealAccent.shade400;
    final borderColor = Colors.teal.shade600;
    final double buttonWidth = switch(orientation) {
      Orientation.portrait => switch (typeSize) {
        MainButtonWidgetTypeSize.large => box.W * 0.7,
        MainButtonWidgetTypeSize.normal => box.W * 0.3,
        MainButtonWidgetTypeSize.small => box.W * 0.15,
      },
      Orientation.landscape => switch (typeSize) {
        MainButtonWidgetTypeSize.large => box.W * 0.3,
        MainButtonWidgetTypeSize.normal => box.W * 0.15,
        MainButtonWidgetTypeSize.small => box.W * 0.075,
      },
    };
    final double buttonHeight = orientation.isLandscape ? (box.H / 8) : (box.H * 0.06 );
    final double fontSize = buttonHeight * 0.4;
    final BorderRadius borderRadius = BorderRadius.all(Radius.elliptical(buttonHeight * 0.35, buttonHeight * 0.42));

    return Padding(
      padding: EdgeInsets.only(
        bottom: verticalPadding == false ? 0 : 25,
        left: 5,
        right: 5,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          elevation: 5,
          shadowColor: shadowColor,
          borderRadius: borderRadius,
          child: Container(
            alignment: Alignment.center,
            height: buttonHeight,
            width: buttonWidth,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.2,
                color: borderColor,
              ),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  enable
                      ? Colors.blueGrey.shade800
                      : Colors.black38,
                  enable
                      ? Colors.blueGrey.shade700
                      : Colors.black26,
                ],
              ),
              borderRadius: borderRadius,
            ),
            child: icon ?? BorderedText(
              strokeWidth: 1.5,
              strokeJoin: StrokeJoin.round,
              child: Text(
                text,
                style: TextStyle(
                  color: enable
                      ? Colors.white
                      : Colors.grey.shade400,
                  // fontSize: 19,
                  fontSize: fontSize,
                  shadows: const [
                    Shadow(
                      offset: Offset(-0.5, -0.5),
                      blurRadius: 3.5,
                      color: Colors.white,
                    ),
                    Shadow(
                      offset: Offset(1.2, 1.2),
                      blurRadius: 5.0,
                      color: Colors.black87,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
