import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The immersive teal canvas used behind content on BOB's dark screens.
///
/// Instead of a flat [AppColors.bgBase] fill, this paints:
///  1. A soft vertical gradient (a lighter deep-teal at the top easing into the
///     sunken teal at the bottom) so the canvas has depth and a light source.
///  2. A fine film-grain noise layer plus a very subtle dot weave, both at low
///     opacity, so the teal has texture up close and never reads as a flat,
///     "jarring" slab of color, without ever competing with content.
///
/// Wrap a screen's body in this and set the [Scaffold.backgroundColor] to
/// transparent. Content is passed as [child] and painted on top.
///
/// [seed] fixes the random grain so it is stable across rebuilds (no shimmer).
class TealBackground extends StatelessWidget {
  const TealBackground({super.key, required this.child, this.seed = 7});

  final Widget child;

  /// Fixed seed for the deterministic grain scatter.
  final int seed;

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
        painter: _TealTexturePainter(seed: seed),
        child: child,
      ),
    );
  }
}

/// Paints two stacked textures on the teal canvas:
///  - a fine, deterministic grain (tiny light and dark specks) for a filmic
///    noise feel, and
///  - a faint evenly spaced dot weave for a subtle structured pattern.
///
/// Both are very low alpha and purely cosmetic (never hit-tested).
class _TealTexturePainter extends CustomPainter {
  _TealTexturePainter({required this.seed});

  final int seed;

  // Dot weave.
  static const double _spacing = 26.0;
  static const double _dotRadius = 1.1;
  final Paint _dot = Paint()..color = const Color(0x0FFFFFFF); // ~6% white

  // Grain: how many specks per 100x100 area, and their max size.
  static const double _grainDensity = 0.9;
  static const double _grainMaxSize = 1.4;

  @override
  void paint(Canvas canvas, Size size) {
    _paintGrain(canvas, size);
    _paintDots(canvas, size);
  }

  void _paintGrain(Canvas canvas, Size size) {
    // A seeded RNG keeps the grain identical on every repaint, so it reads as a
    // baked-in texture rather than TV static.
    final math.Random rng = math.Random(seed);
    final int count =
        ((size.width * size.height) / (100 * 100) * 100 * _grainDensity)
            .round();
    final Paint light = Paint()..color = const Color(0x0AFFFFFF); // ~4% white
    final Paint dark = Paint()..color = const Color(0x0A000000); // ~4% black
    for (int i = 0; i < count; i++) {
      final double x = rng.nextDouble() * size.width;
      final double y = rng.nextDouble() * size.height;
      final double s = 0.4 + rng.nextDouble() * _grainMaxSize;
      // Mix light and dark specks so the grain reads on both the lighter top
      // and the darker bottom of the gradient.
      final Paint p = rng.nextBool() ? light : dark;
      canvas.drawCircle(Offset(x, y), s / 2, p);
    }
  }

  void _paintDots(Canvas canvas, Size size) {
    // Offset every other row by half a cell for a subtle diagonal weave.
    int row = 0;
    for (double y = _spacing / 2; y < size.height; y += _spacing) {
      final double xOffset = row.isEven ? 0 : _spacing / 2;
      for (double x = _spacing / 2 + xOffset; x < size.width; x += _spacing) {
        canvas.drawCircle(Offset(x, y), _dotRadius, _dot);
      }
      row++;
    }
  }

  @override
  bool shouldRepaint(covariant _TealTexturePainter oldDelegate) =>
      oldDelegate.seed != seed;
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
