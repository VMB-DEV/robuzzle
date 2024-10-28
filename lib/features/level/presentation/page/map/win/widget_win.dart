import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/widgets/BlurryContainer.dart';
import 'package:robuzzle/features/level/presentation/page/map/win/painter_winner_star.dart';

class WinWidget extends StatefulWidget {
  const WinWidget({super.key});

  @override
  State<WinWidget> createState() => _WinWidgetState();
}

class _WinWidgetState extends State<WinWidget> with TickerProviderStateMixin {
  late AnimationController _loopController;
  late AnimationController _displayController;

  @override
  void initState() {
    super.initState();
    _loopController = AnimationController(
      lowerBound: 0.7,
      upperBound: 1.0,
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _displayController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _loopController.dispose();
    _displayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, box) {
          return Stack(
            children: [
              _starBackground(box),
              _foreground(box),
            ],
          );
        }
    );
  }

  Widget _winText(BoxConstraints box) {
    return BorderedText(
      strokeWidth: 2.5,
      strokeJoin: StrokeJoin.round,
      strokeColor: Colors.yellow.shade700,
      child: Text(
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          shadows: [
            const Shadow(
              offset: Offset(-0.5, -0.5),
              blurRadius: 3.5,
              color: Colors.black,
            ),
            Shadow(
              offset: const Offset(1.2, 1.2),
              blurRadius: 5.0,
              color: Colors.yellow.shade700,
            ),
          ],
        ),
        "WIN",
      ),
    );
  }

  Widget _starBackground(BoxConstraints box) {
    return AnimatedBuilder(
      animation: _displayController,
      builder: (ctx, child) {
        return Opacity(
          opacity: _displayController.value,
          child: SizedBox(
            height: box.H,
            width: box.W,
            child: AnimatedBuilder(
              animation: _loopController,
              child: child,
              builder: (ctx, child) {
                return CustomPaint(
                  painter: WinnerStarPainter(_loopController.value),
                  child: Container(),
                );
              },
            ),
          ),
        );
      }
    );
  }

  Widget _foreground(BoxConstraints box) {
    return BlurryContainer(
      height: box.H,
      width: box.W,
      alignment: Alignment.center,
      borderRadius: BorderRadius.zero,
      blurSigmaX: 4,
      blurSigmaY: 4,
      child: SizedBox(
        height: box.H,
        width: box.W,
        child: _winText(box),
      ),
    );
  }
}
