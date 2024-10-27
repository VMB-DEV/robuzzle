import 'package:flutter/material.dart';

class MapCaseWidget extends StatelessWidget {
  final String char;
  final bool borders;
  final double size;

  const MapCaseWidget({
    required this.char,
    required this.borders,
    required this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return char == ' ' ? Container() : GestureDetector(
      // onTap: onTap,
      child: Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: borders ? Colors.white70 : Colors.transparent,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Center( child: Container(
          height: size - 3,
          width: size - 3,
          decoration: BoxDecoration(
            boxShadow: [
              const BoxShadow(
                offset: Offset(1, 1),
                blurRadius: 5.0,
                color: Colors.black54,
              ),
              BoxShadow(
                offset: const Offset(0.5, 0.5),
                blurRadius: 4,
                color: switch (char) {
                  'r' || 'R' => Colors.redAccent.shade700,
                  'b' || 'B' => Colors.blue.shade700,
                  'g' || 'G' => Colors.greenAccent.shade700,
                  String() => Colors.grey,
                },
              ),
            ],
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: switch (char) {
                  'r' || 'R' => [Colors.red.shade900, Colors.red.shade700, Colors.red.shade600, Colors.red.shade400,],
                  'b' || 'B' => [Colors.indigo.shade700, Colors.indigo, Colors.blue.shade600],
                  'g' || 'G' => [Colors.teal.shade800, Colors.green.shade700],
                  String() => [Colors.grey, Colors.blueGrey],
                }),
            border: Border.all(
              color: borders ? Colors.white : switch (char) {
                'r' || 'R' => Colors.redAccent.shade400,
                'b' || 'B' => Colors.blue.shade500,
                'g' || 'G' => Colors.greenAccent.shade400,
                String() => Colors.grey,
              },
              // width: 0.5,
              width: 0.3,
            ),
            borderRadius: BorderRadius.circular(2.0),
          ),
        ),
        ),
      ),
    );
  }
}

