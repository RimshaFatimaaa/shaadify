import 'dart:math' as math;
import 'package:flutter/material.dart';

class SparkleEffect extends StatefulWidget {
  final Widget child;
  final int sparkleCount;

  const SparkleEffect({
    super.key,
    required this.child,
    this.sparkleCount = 20,
  });

  @override
  State<SparkleEffect> createState() => _SparkleEffectState();
}

class _SparkleEffectState extends State<SparkleEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Sparkle> _sparkles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _sparkles = List.generate(
      widget.sparkleCount,
      (index) => Sparkle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        delay: _random.nextDouble(),
        size: _random.nextDouble() * 4 + 2,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: SparklePainter(
                sparkles: _sparkles,
                animationValue: _controller.value,
              ),
              size: Size.infinite,
            );
          },
        ),
      ],
    );
  }
}

class Sparkle {
  final double x;
  final double y;
  final double delay;
  final double size;

  Sparkle({
    required this.x,
    required this.y,
    required this.delay,
    required this.size,
  });
}

class SparklePainter extends CustomPainter {
  final List<Sparkle> sparkles;
  final double animationValue;

  SparklePainter({
    required this.sparkles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFFFFD700), // Gold
      const Color(0xFFFFA500), // Orange
      const Color(0xFFFF6B6B), // Coral
      const Color(0xFFFF1493), // Deep pink
      Colors.white,
    ];

    for (var sparkle in sparkles) {
      final adjustedValue = (animationValue + sparkle.delay) % 1.0;
      final opacity = (math.sin(adjustedValue * math.pi * 2) + 1) / 2;
      final sparkleSize = sparkle.size * (0.5 + opacity * 0.5);

      final paint = Paint()
        ..color = colors[(sparkle.size * 10).toInt() % colors.length]
            .withValues(alpha: opacity * 0.8)
        ..style = PaintingStyle.fill;

      final x = sparkle.x * size.width;
      final y = sparkle.y * size.height;

      // Draw sparkle as a star
      _drawStar(canvas, Offset(x, y), sparkleSize, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final angle = (i * 4 * math.pi / 5) - math.pi / 2;
      final x = center.dx + math.cos(angle) * radius;
      final y = center.dy + math.sin(angle) * radius;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SparklePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}

