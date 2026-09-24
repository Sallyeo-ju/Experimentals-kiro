import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The official BOB logo mark: an arrow curling into a loop shaped like a
/// lowercase "b", with a paw print badge inside the loop, next to the "ob"
/// wordmark baked into the same artwork.
///
/// Sourced from the brand asset at `assets/images/bob_logo.png` (transparent
/// background), so this renders identically everywhere the logo appears
/// instead of approximating the mark with a custom painter.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 44,
    this.showWordmark = true,
    this.onTeal = true,
  });

  /// Edge length of the square mark. The mark image is roughly 488x511, so the
  /// rendered height is derived from this to preserve its aspect ratio.
  final double size;

  /// When true, a small "Analis saham AI" tagline is shown under the mark.
  /// The "Bob" wordmark itself is already part of the logo artwork.
  final bool showWordmark;

  /// When true, the tagline color is tuned for the teal canvas, otherwise for
  /// the off-white surface.
  final bool onTeal;

  /// Native aspect ratio (width / height) of the source artwork.
  static const double _aspectRatio = 488 / 511;

  @override
  Widget build(BuildContext context) {
    final Color subColor =
        onTeal ? AppColors.textOnTeal2 : AppColors.textSecondary;

    final Widget mark = Image.asset(
      'assets/images/bob_logo.png',
      height: size,
      width: size * _aspectRatio,
      fit: BoxFit.contain,
    );

    if (!showWordmark) {
      return mark;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        mark,
        SizedBox(height: size * 0.12),
        Text(
          'Analis saham AI',
          style: TextStyle(
            color: subColor,
            fontSize: size * 0.26,
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
      ],
    );
  }
}
