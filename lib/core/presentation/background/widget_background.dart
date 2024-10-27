import 'package:flutter/material.dart';
import 'package:robuzzle/core/presentation/background/painter_background.dart';

class AppBackground extends StatelessWidget {
  static const backgroundPainter = BackgroundPainter();
  final Widget child;

  const AppBackground({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned.fill(
              child: RepaintBoundary(
                child: CustomPaint(
                  painter: backgroundPainter,
                  size: Size.infinite,
                ),
              ),
            ),
            Positioned.fill(
              child: NotificationListener<ScrollNotification>(
                onNotification: (_) => true,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}