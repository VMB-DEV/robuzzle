import 'package:flutter/animation.dart';
import 'package:hive_flutter/hive_flutter.dart';

extension BoxExtension<T> on Box<T> {
  Future<void> containedOrPut(dynamic key, T value) async {
    if (containsKey(key)) {
      await put(key, value);
    }
  }
}

extension AnimationControllerExtension on AnimationController {
  void backToNorm() {
    value = upperBound;
  }
}