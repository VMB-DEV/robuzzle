import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class AnimatedGlowingTrashIcon extends StatefulWidget {
  final double size;

  const AnimatedGlowingTrashIcon({required this.size, super.key});

  @override
  State<AnimatedGlowingTrashIcon> createState() => _AnimatedGlowingTrashIconState();
}

class _AnimatedGlowingTrashIconState extends State<AnimatedGlowingTrashIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      // duration: Duration(milliseconds: duration),
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
        final Color color = Color.lerp(
          Colors.white70,
          Colors.white,
          _animation.value,
        )!;
        return Icon(
          Symbols.delete_outline_rounded,
          weight: 700,
          grade: 0.5,
          opticalSize: 50,
          size: widget.size,
          shadows: const [ Shadow(color: Colors.red, blurRadius: 1.5) ],
          color: color,
        );
      },
    );
  }
}
