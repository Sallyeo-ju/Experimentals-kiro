import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The immersive teal canvas used behind content on BOB's dark screens.
///
/// Instead of a flat [AppColors.bgBase] fill, this paints:
///  1. A soft vertical gradient (a lighter deep-teal at the top easing into the
///     sunken teal at the bottom) so the canvas has depth and a light source.
///  2. A very subtle dot pattern, low opacity, that gives the surface texture
///     up close without ever competing with content.
///
/// Wrap a screen's body in this and set the [Scaffold.backgroundColor] to
/// transparent. Content is passed as [child] and painted on top.
class TealBackground extends StatelessWidget {
  const TealBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            AppColors.bgElevated,
            AppColors.bgBase,
            AppColors.bgSunken,
          ],
          stops: <double>[0.0, 0.55, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: _DotPatternPainter(),
        child: child,
      ),
    );
  }
}

/// Paints a faint, evenly spaced dot grid. Very low alpha so it reads as texture
/// rather than decoration, and it is purely cosmetic (never hit-tested).
class _DotPatternPainter extends CustomPainter {
  static const double _spacing = 26.0;
  static const double _radius = 1.1;

  final Paint _dot = Paint()..color = const Color(0x0FFFFFFF); // ~6% white

  @override
  void paint(Canvas canvas, Size size) {
    // Offset every other row by half a cell for a subtle diagonal weave.
    int row = 0;
    for (double y = _spacing / 2; y < size.height; y += _spacing) {
      final double xOffset = row.isEven ? 0 : _spacing / 2;
      for (double x = _spacing / 2 + xOffset; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _radius, _dot);
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(covariant _DotPatternPainter oldDelegate) => false;
}

/// A decorative soft radial "glow" blob, used sparingly behind hero content
/// (for example the splash logo) to add warmth to the teal canvas. Not
/// interactive. [color] defaults to a faint gold wash.
class GlowBlob extends StatelessWidget {
  const GlowBlob({
    super.key,
    this.size = 320,
    this.color = const Color(0x1FE9B84A),
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[color, color.withOpacity(0)],
          ),
        ),
      ),
    );
  }
}
