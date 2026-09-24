import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The BOB logo widget that renders the real brand logo image asset.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 44,
    this.showWordmark = true,
    this.onTeal = true,
    this.assetPath = 'assets/images/logo.png',
  });

  /// Edge length or height of the logo image.
  final double size;

  /// When true the BOB wordmark is shown next to the mark.
  final bool showWordmark;

  /// When true text colors are tuned for the teal canvas, otherwise for the
  /// off-white surface.
  final bool onTeal;

  /// Asset path for the logo image.
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final Color wordColor =
        onTeal ? AppColors.textOnTeal : AppColors.textPrimary;
    final Color subColor =
        onTeal ? AppColors.textOnTeal2 : AppColors.textSecondary;

    final Widget mark = Image.asset(
      assetPath,
      height: size,
      width: size,
      fit: BoxFit.contain,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return Icon(
          Icons.interests_rounded,
          size: size,
          color: onTeal ? AppColors.textOnTeal : AppColors.textPrimary,
        );
      },
    );

    if (!showWordmark) {
      return mark;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        mark,
        SizedBox(width: size * 0.28),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'BOB',
              style: TextStyle(
                color: wordColor,
                fontSize: size * 0.62,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                height: 1,
              ),
            ),
            SizedBox(height: size * 0.06),
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
        ),
      ],
    );
  }
}
