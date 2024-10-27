import 'package:flutter/material.dart';

extension OrientationExtension on Orientation {
  bool get isPortrait => this == Orientation.portrait;
  bool get isLandscape => this == Orientation.landscape;
}
