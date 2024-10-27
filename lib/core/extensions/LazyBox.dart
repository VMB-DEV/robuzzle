import 'package:hive_flutter/hive_flutter.dart';

extension LazyBoxExtension<T> on LazyBox<T> {
  Future<void> containedOrPut(dynamic key, T value) async {
    if (containsKey(key)) {
      await put(key, value);
    }
  }
}