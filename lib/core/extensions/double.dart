
import 'package:flutter/material.dart';

extension DoubleExtension on double {
  Size toSize() => Size(this, this);
}
