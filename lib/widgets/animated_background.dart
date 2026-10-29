import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedMehendiBackground extends StatefulWidget {
  final Widget child;
  final bool showParticles;

  const AnimatedMehendiBackground({
    super.key,
    required this.child,
    this.showParticles = true,
  });

  @override
  State<AnimatedMehendiBackground> createState() => _AnimatedMehendiBackgroundState();
}

class _AnimatedMehendiBackgroundState extends State<AnimatedMehendiBackground>
    with TickerProviderStateMixin {
  late AnimationController _particleController;
  late AnimationController _gradientController;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _particles = List.generate(
      30,
      (index) => Particle(
        x: math.Random().nextDouble(),
        y: math.Random().nextDouble(),
        size: math.Random().nextDouble() * 3 + 1,
        speed: math.Random().nextDouble() * 0.5 + 0.1,
      ),
    );
  }

  @override
  void dispose() {
    _particleController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_particleController, _gradientController]),
      builder: (context, child) {
        return CustomPaint(
          painter: MehendiBackgroundPainter(
            particles: _particles,
            animationValue: _particleController.value,
            gradientValue: _gradientController.value,
            showParticles: widget.showParticles,
          ),
          child: widget.child,
        );
      },
    );
  }
}

class Particle {
  double x;
  double y;
  double size;
  double speed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}

class MehendiBackgroundPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;
  final double gradientValue;
  final bool showParticles;

  MehendiBackgroundPainter({
    required this.particles,
    required this.animationValue,
    required this.gradientValue,
    required this.showParticles,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Animated gradient background
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color.lerp(
          const Color(0xFFFFE5E5), // Light pink
          const Color(0xFFFFF4E6), // Light orange
          gradientValue,
        )!,
        Color.lerp(
          const Color(0xFFFFF0F5), // Lavender blush
          const Color(0xFFFFE4B5), // Moccasin
          gradientValue,
        )!,
        Color.lerp(
          const Color(0xFFFFF8DC), // Cornsilk
          const Color(0xFFFFE5CC), // Peach
          gradientValue,
        )!,
      ],
    );

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    if (!showParticles) return;

    // Draw floating particles (mehendi-inspired)
    final particlePaint = Paint()
      ..style = PaintingStyle.fill
      ..color = const Color(0xFFFF6B6B).withOpacity(0.3);

    for (var particle in particles) {
      final x = (particle.x + animationValue * particle.speed) % 1.0;
      final y = (particle.y + animationValue * particle.speed * 0.5) % 1.0;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particle.size * 2,
        particlePaint..color = _getParticleColor(particle).withOpacity(0.2),
      );
    }

    // Draw mehendi pattern decorations
    _drawMehendiPatterns(canvas, size);
  }

  Color _getParticleColor(Particle particle) {
    final colors = [
      const Color(0xFFFF6B6B), // Coral red
      const Color(0xFFFFA500), // Orange
      const Color(0xFFFFD700), // Gold
      const Color(0xFFFF69B4), // Hot pink
      const Color(0xFFFF1493), // Deep pink
    ];
    return colors[(particle.size * 10).toInt() % colors.length];
  }

  void _drawMehendiPatterns(Canvas canvas, Size size) {
    final patternPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFFFF6B6B).withOpacity(0.1);

    // Draw decorative mehendi-inspired swirls
    final path = Path();
    final centerX = size.width * 0.1;
    final centerY = size.height * 0.1;

    // Swirl pattern
    for (int i = 0; i < 3; i++) {
      path.reset();
      path.moveTo(centerX + i * 50, centerY + i * 30);
      path.quadraticBezierTo(
        centerX + i * 50 + 20,
        centerY + i * 30 - 20,
        centerX + i * 50 + 40,
        centerY + i * 30,
      );
      path.quadraticBezierTo(
        centerX + i * 50 + 60,
        centerY + i * 30 + 20,
        centerX + i * 50 + 40,
        centerY + i * 30 + 40,
      );
      canvas.drawPath(path, patternPaint);
    }
  }

  @override
  bool shouldRepaint(MehendiBackgroundPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.gradientValue != gradientValue;
  }
}

