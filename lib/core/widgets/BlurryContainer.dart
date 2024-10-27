import 'dart:ui';

import 'package:flutter/material.dart';

import 'clipper_rrect_custom.dart';

class BlurryContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  final Alignment alignment;
  final BorderRadius borderRadius;
  final double blurSigmaY;
  final double blurSigmaX;
  final Widget child;
  const BlurryContainer({
    required this.height,
    required this.width,
    this.color,
    required this.alignment,
    required this.borderRadius,
    required this.blurSigmaX,
    required this.blurSigmaY,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color ?? Colors.transparent,
        borderRadius: borderRadius,
      ),
      child: ClipRRect(
        clipper: CustomRRectClipper(borderRadius: borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: blurSigmaX, sigmaX: blurSigmaY),
          child: child,
        ),
      )
    );
  }
}
