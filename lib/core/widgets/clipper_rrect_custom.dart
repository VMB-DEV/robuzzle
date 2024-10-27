import 'package:flutter/material.dart';

class CustomRRectClipper extends CustomClipper<RRect> {
  final BorderRadius borderRadius;
  CustomRRectClipper({required this.borderRadius});

  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndCorners(
      Rect.fromLTRB(0, 0, size.width, size.height),
      topRight: borderRadius.topRight,
      topLeft: borderRadius.topLeft,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}

class CustomFullRectClipper extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    return RRect.fromLTRBR(0, 0, size.width, size.height, Radius.elliptical(15, 20));
  }

  @override
  bool shouldReclip(covariant CustomClipper<RRect> oldClipper) => false;
}
