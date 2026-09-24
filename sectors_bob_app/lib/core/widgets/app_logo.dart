import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The BOB logo mark: an arrow curling into a loop, with a small paw print
/// badge sitting inside the loop, next to the BOB wordmark.
///
/// This uses dedicated brand colors ([AppColors.brandMark] and
/// [AppColors.brandPaw]), not the bullish and bearish data colors, so the logo
/// never reads as a stock signal. Green and red stay reserved for data.
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
      child: CustomPaint(
        painter: _ArrowLoopPawPainter(),
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

/// Paints the BOB mark: an arrow rising then curling into a loop shaped like a
/// lowercase b, with a small paw print sitting inside the loop.
///
/// The stroke is drawn with round caps and joins so it reads as one continuous
/// shape, similar to the reference logo. Proportions are relative to [size] so
/// the mark stays crisp at every scale the app uses (splash, auth header).
class _ArrowLoopPawPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double s = size.shortestSide;
    final double strokeWidth = s * 0.13;

    final Paint markPaint = Paint()
      ..color = AppColors.brandMark
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // The loop sits in the lower two thirds of the mark, like the bowl of a
    // lowercase b. The stem rises from the top of the loop and kinks left into
    // an arrowhead near the top, echoing the upward arrow in the reference mark.
    final Rect loopRect = Rect.fromCircle(
      center: Offset(s * 0.52, s * 0.62),
      radius: s * 0.28,
    );

    final Path loopPath = Path()
      ..addArc(loopRect, _degToRad(-40), _degToRad(300));
    canvas.drawPath(loopPath, markPaint);

    final Path stemPath = Path()
      ..moveTo(s * 0.30, s * 0.62)
      ..lineTo(s * 0.30, s * 0.20)
      ..lineTo(s * 0.16, s * 0.20);
    canvas.drawPath(stemPath, markPaint);

    // Arrowhead at the top of the stem.
    final Path arrowPath = Path()
      ..moveTo(s * 0.28, s * 0.08)
      ..lineTo(s * 0.16, s * 0.20)
      ..lineTo(s * 0.28, s * 0.32);
    canvas.drawPath(arrowPath, markPaint);

    _paintPaw(canvas, center: Offset(s * 0.56, s * 0.64), scale: s * 0.20);
  }

  /// Paints a small paw print: one round pad plus three toe pads above it.
  void _paintPaw(Canvas canvas, {required Offset center, required double scale}) {
    final Paint pawPaint = Paint()..color = AppColors.brandPaw;

    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, scale * 0.28),
        width: scale * 0.78,
        height: scale * 0.62,
      ),
      pawPaint,
    );

    const List<Offset> toeOffsets = <Offset>[
      Offset(-0.36, -0.30),
      Offset(0.0, -0.42),
      Offset(0.36, -0.30),
    ];
    for (final Offset toe in toeOffsets) {
      canvas.drawOval(
        Rect.fromCenter(
          center: center + Offset(toe.dx * scale, toe.dy * scale),
          width: scale * 0.30,
          height: scale * 0.38,
        ),
        pawPaint,
      );
    }
  }

  double _degToRad(double degrees) => degrees * 3.14159265 / 180;

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
