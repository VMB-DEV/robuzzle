import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class ColorsExtensions extends ThemeExtension<ColorsExtensions> {
  final Color redCase;
  final Color blueCase;
  final Color greenCase;
  final Color greyCase;

  const ColorsExtensions({
    required this.redCase,
    required this.blueCase,
    required this.greenCase,
    required this.greyCase,
  });

  @override
  ThemeExtension<ColorsExtensions> copyWith({
    Color? redCase,
    Color? blueCase,
    Color? greenCase,
    Color? greyCase,
  }) {
    return ColorsExtensions(
      redCase: redCase ?? this.redCase,
      blueCase: blueCase ?? this.blueCase,
      greenCase: greenCase ?? this.greenCase,
      greyCase: greyCase ?? this.greyCase,
    );
  }

  @override
  ThemeExtension<ColorsExtensions> lerp(covariant ThemeExtension<ColorsExtensions>? other, double t) {
    throw UnimplementedError();
  }
}