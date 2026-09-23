import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The BOB logo mark: a rounded square split diagonally into a green half and a
/// red half, echoing the up/down data signals, next to the BOB wordmark.
///
/// The split square is decorative branding, not a data readout, so it is the one
/// place the signal colors sit side by side outside of data rows.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 44,
    this.showWordmark = true,
    this.onTeal = true,
  });

  /// Edge length of the square mark.
  final double size;

  /// When true the BOB wordmark is shown next to the mark.
  final bool showWordmark;

  /// When true text colors are tuned for the teal canvas, otherwise for the
  /// off-white surface.
  final bool onTeal;

  @override
  Widget build(BuildContext context) {
    final Color wordColor =
        onTeal ? AppColors.textOnTeal : AppColors.textPrimary;
    final Color subColor =
        onTeal ? AppColors.textOnTeal2 : AppColors.textSecondary;

    final Widget mark = SizedBox(
      height: size,
      width: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.24),
        child: CustomPaint(
          painter: _SplitSquarePainter(),
        ),
      ),
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

/// Paints the two-tone split square used by the logo mark.
class _SplitSquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint greenPaint = Paint()..color = AppColors.bullish;
    final Paint redPaint = Paint()..color = AppColors.bearish;

    // Top-left triangle in green, bottom-right triangle in red.
    final Path greenPath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    final Path redPath = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(greenPath, greenPaint);
    canvas.drawPath(redPath, redPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
