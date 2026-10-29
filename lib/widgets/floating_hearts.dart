import 'dart:math';
import 'package:flutter/material.dart';

class FloatingHearts extends StatefulWidget {
  final int heartCount;
  final Color? heartColor;

  const FloatingHearts({
    super.key,
    this.heartCount = 5,
    this.heartColor,
  });

  @override
  State<FloatingHearts> createState() => _FloatingHeartsState();
}

class _FloatingHeartsState extends State<FloatingHearts>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Heart> _hearts;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _hearts = List.generate(
      widget.heartCount,
      (index) => Heart(
        x: _random.nextDouble(),
        delay: _random.nextDouble() * 2,
        size: _random.nextDouble() * 15 + 10,
        speed: _random.nextDouble() * 0.5 + 0.3,
      ),
    );

    _controllers = List.generate(
      widget.heartCount,
      (index) => AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: (3000 + _random.nextInt(2000)).toInt(),
        ),
      )..repeat(),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        widget.heartCount,
        (index) => AnimatedBuilder(
          animation: _controllers[index],
          builder: (context, child) {
            final heart = _hearts[index];
            final value = _controllers[index].value;
            final y = (heart.y - value * heart.speed) % 1.0;
            final opacity = (1.0 - (value * 2).clamp(0.0, 1.0));

            return Positioned(
              left: heart.x * MediaQuery.of(context).size.width,
              top: y * MediaQuery.of(context).size.height,
              child: Opacity(
                opacity: opacity,
                child: Icon(
                  Icons.favorite,
                  color: widget.heartColor ??
                      const Color(0xFFFF6B6B).withOpacity(0.6),
                  size: heart.size,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Heart {
  final double x;
  double y;
  final double size;
  final double speed;
  final double delay;

  Heart({
    required this.x,
    this.y = 1.0,
    required this.size,
    required this.speed,
    required this.delay,
  });
}

