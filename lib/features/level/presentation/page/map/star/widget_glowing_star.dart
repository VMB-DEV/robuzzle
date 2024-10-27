import 'dart:math';

import 'package:flutter/material.dart';
import 'package:robuzzle/features/level/presentation/page/map/star/painter_star.dart';

class AnimatedGlowingStar extends StatefulWidget {
  final double size;

  const AnimatedGlowingStar({this.size = 100, super.key});

  @override
  _AnimatedGlowingStarState createState() => _AnimatedGlowingStarState();
}

class _AnimatedGlowingStarState extends State<AnimatedGlowingStar> with SingleTickerProviderStateMixin {
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {

        return
          CustomPaint(
          size: Size(widget.size, widget.size,),
          painter: StarPainter(_animation.value,),
        );
      },
    );
  }
}

