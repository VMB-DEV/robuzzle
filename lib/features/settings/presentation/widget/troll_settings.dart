import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsTroll {
  final counter;
  const SettingsTroll({this.counter});


  SnackBar get snackBar => switch(counter) {
    0 => _snackBar('Nope'),
    1 => _snackBar('Nope ...'),
    2 => _snackBar('There is no way.'),
    3 => _snackBar('Cmon !'),
    4 => _snackBar('Not even in a million years'),
    5 => _snackBar('Listen to Michael'),
    _ => _snackBar('Nope'),
  };
  static int maxCount = 5;

  SnackBar _snackBar(String str) => SnackBar(
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5))),
    backgroundColor: const Color(0xFF323232),
    duration: const Duration(milliseconds: 700),
    elevation: 25,
    content: BorderedText(
      strokeWidth: 2,
      strokeJoin: StrokeJoin.round,
      strokeColor: Colors.black,
      child: Text(
        str,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 15,
          shadows: [
            Shadow(
              offset: Offset(1.2, 1.2),
              blurRadius: 5.0,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('Nope'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    return snackBar;
  }
}