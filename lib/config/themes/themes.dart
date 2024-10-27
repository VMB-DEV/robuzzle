import 'package:flutter/material.dart';
import 'package:flutter/src/cupertino/theme.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'colors_extension.dart';

ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      // primary: Colors.blueGrey.shade700,
      primary: Colors.blueGrey.shade700,
      secondary: Colors.blueGrey.shade700,
      surface: Colors.blueGrey.shade900,
      tertiary: Colors.amber.shade700,
      surfaceContainerLow: Colors.amber.shade800,
      surfaceContainerLowest: Colors.amber.shade400,
      surfaceContainerHigh: Colors.grey.shade700,
    ),
    useMaterial3: true,
    extensions: [
      ColorsExtensions(
        redCase: Colors.red.shade700,
        blueCase: Colors.blue.shade700,
        greenCase: Colors.green.shade700,
        greyCase: Colors.blueGrey.shade700,
      )
    ]
);

ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.blueGrey.shade700,
      secondary: Colors.blueGrey.shade400,
      surface: Colors.grey.shade200,
      background: Colors.grey.shade300,
      tertiary: Colors.greenAccent,
      surfaceContainerLow: Colors.green.shade200,
      surfaceContainerLowest: Colors.green.shade700,
      surfaceContainerHigh: Colors.grey.shade700,
    ),
    useMaterial3: true,
    extensions: [
      ColorsExtensions(
        redCase: Colors.red.shade700,
        blueCase: Colors.blue.shade700,
        greenCase: Colors.green.shade700,
        greyCase: Colors.blueGrey.shade700,
      )
    ]
);

