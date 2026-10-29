import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SafeBackgroundImage extends StatelessWidget {
  final String imagePath;
  final Widget child;
  final double opacity;

  const SafeBackgroundImage({
    super.key,
    required this.imagePath,
    required this.child,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkAssetExists(imagePath),
      builder: (context, snapshot) {
        final hasImage = snapshot.data ?? false;

        return Container(
          decoration: BoxDecoration(
            image: hasImage
                ? DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.white.withValues(alpha: opacity),
                      BlendMode.dstATop,
                    ),
                  )
                : null,
            color: const Color(0xFF), // Beige background
          ),
          child: child,
        );
      },
    );
  }

  Future<bool> _checkAssetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      return false;
    }
  }
}
