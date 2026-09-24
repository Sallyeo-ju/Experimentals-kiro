import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The BOB logo widget that renders the brand logo image asset.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 72,
    this.showSubtitle = true,
    this.showWordmark = true,
    this.onTeal = true,
    this.assetPath = 'assets/images/logo.png',
  });

  /// Height of the logo PNG image.
  final double size;

  /// When true the subtitle ('Analis saham AI') is shown below the logo image.
  final bool showSubtitle;

  /// Backwards-compatible alias for [showSubtitle].
  final bool showWordmark;

  /// When true text colors are tuned for the teal canvas, otherwise for the
  /// off-white surface.
  final bool onTeal;

  /// Asset path for the logo image.
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final bool displaySubtitle = showSubtitle && showWordmark;
    final Color subColor =
        onTeal ? AppColors.textOnTeal2 : AppColors.textSecondary;

    final Widget logoImage = Image.asset(
      assetPath,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Icon(
          Icons.interests_rounded,
          size: size,
          color: onTeal ? AppColors.textOnTeal : AppColors.textPrimary,
        );
      },
    );

    if (!displaySubtitle) {
      return logoImage;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        logoImage,
        SizedBox(height: size * 0.10),
        Text(
          'Analis saham AI',
          style: TextStyle(
            color: subColor,
            fontSize: (size * 0.18).clamp(12.0, 16.0),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            height: 1,
          ),
        ),
      ],
    );
  }
}
