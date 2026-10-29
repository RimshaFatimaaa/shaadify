import 'package:flutter/material.dart';
import '../screens/give_feedback_screen.dart';

class DraggableFeedbackIcon extends StatefulWidget {
  const DraggableFeedbackIcon({super.key});

  @override
  State<DraggableFeedbackIcon> createState() => _DraggableFeedbackIconState();
}

class _DraggableFeedbackIconState extends State<DraggableFeedbackIcon>
    with SingleTickerProviderStateMixin {
  double? _right;
  double? _bottom;
  bool _isDragging = false;
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _sparkleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Bounce animation (up and down movement)
    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 8.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Sparkle animation (for shimmer effect) - faster cycle
    _sparkleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.0, end: 0.3), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.3, end: 0.7), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 0.7, end: 1.0), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 0.7), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 0.7, end: 0.3), weight: 2),
      TweenSequenceItem(tween: Tween<double>(begin: 0.3, end: 0.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bottomNavHeight = 60; // Approximate bottom nav height
    final iconSize = 48.0; // Smaller size
    
    // Initialize position on first build - bottom-right corner
    _right ??= 20.0; // 20px from right edge
    _bottom ??= bottomNavHeight + 20.0; // Above bottom nav + padding
    
    return Positioned(
      right: _right,
      bottom: _bottom,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            _isDragging = true;
            final screenWidth = MediaQuery.of(context).size.width;
            final screenHeight = MediaQuery.of(context).size.height;
            final bottomNavHeight = 60;
            
            // Convert pan delta to right/bottom coordinates
            // When dragging right, right decreases; when dragging down, bottom decreases
            _right = (_right! - details.delta.dx).clamp(0.0, screenWidth - iconSize);
            _bottom = (_bottom! - details.delta.dy).clamp(bottomNavHeight + 10.0, screenHeight - 10.0);
          });
        },
        onPanEnd: (details) {
          setState(() {
            _isDragging = false;
          });
        },
        onTap: () {
          if (!_isDragging) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GiveFeedbackScreen(),
              ),
            );
          }
        },
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, -_bounceAnimation.value),
              child: Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF6B2C3E),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                    // Sparkle glow effect - more prominent
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.8 * _sparkleAnimation.value),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.4 * _sparkleAnimation.value),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.feedback,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
