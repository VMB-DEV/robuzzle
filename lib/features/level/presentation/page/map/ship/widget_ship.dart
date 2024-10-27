import 'dart:math';

import 'package:flutter/material.dart';
import 'package:robuzzle/features/level/presentation/page/map/ship/painter_ship.dart';

class AnimatedShip extends StatefulWidget {
  final double size;
  final double rotation;

  const AnimatedShip({required this.rotation, this.size = 100, super.key});

  @override
  _AnimatedShipState createState() => _AnimatedShipState();
}

class _AnimatedShipState extends State<AnimatedShip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
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
        return Transform.rotate(
          angle: widget.rotation,
          child: CustomPaint(
            size: Size(widget.size, widget.size),
            painter: ShipPainter(_animation.value),
          ),
        );
      },
    );
  }
}

