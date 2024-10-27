import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:robuzzle/core/extensions/constraints.dart';
import 'package:robuzzle/core/widgets/BlurryContainer.dart';
import 'package:robuzzle/features/level/presentation/page/map/win/painter_winner_star.dart';

import '../../../../../../core/log/consolColors.dart';

class WinWidget extends StatefulWidget {
  const WinWidget({super.key});

  @override
  State<WinWidget> createState() => _WinWidgetState();
}

class _WinWidgetState extends State<WinWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: WinnerStarPainter(_animation.value),
              child: BlurryContainer(
                height: box.H,
                width: box.W,
                alignment: Alignment.center,
                borderRadius: BorderRadius.zero,
                blurSigmaX: 4,
                blurSigmaY: 4,
                child:  Container(
                  height: box.H,
                  width: box.W,
                  alignment: Alignment.center,
                  child: BorderedText(
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
                  ),
                ),
              ),
            );
          },
            // );
            // return CustomPaint(
            //     painter: WinnerStarPainter(_animation.value),
            //     child: const Text("WIN")
            //   );
          // },
        );
      }
    );
  }
}
