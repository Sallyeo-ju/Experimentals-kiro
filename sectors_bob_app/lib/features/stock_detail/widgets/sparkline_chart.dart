import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// A lightweight line chart for the stock detail price history.
///
/// It draws the [points] as a smooth polyline with a soft gradient fill. The
/// line color follows the net direction of the series: bullish green when the
/// last point is above the first, bearish red otherwise. Colors here are data
/// only, never actions.
class SparklineChart extends StatelessWidget {
  const SparklineChart({super.key, required this.points, this.height = 140});

  final List<double> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    final bool isUp = points.isNotEmpty && points.last >= points.first;
    final Color lineColor = isUp ? AppColors.bullish : AppColors.bearish;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(points: points, lineColor: lineColor),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.points, required this.lineColor});

  final List<double> points;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) {
      return;
    }

    double min = points.first;
    double max = points.first;
    for (final double p in points) {
      if (p < min) min = p;
      if (p > max) max = p;
    }
    final double range = (max - min).abs() < 0.0001 ? 1 : (max - min);

    const double topPad = 8;
    final double usableHeight = size.height - topPad * 2;
    final double stepX = size.width / (points.length - 1);

    Offset pointAt(int i) {
      final double x = stepX * i;
      final double normalized = (points[i] - min) / range;
      final double y = topPad + (1 - normalized) * usableHeight;
      return Offset(x, y);
    }

    final Path linePath = Path()..moveTo(pointAt(0).dx, pointAt(0).dy);
    for (int i = 1; i < points.length; i++) {
      linePath.lineTo(pointAt(i).dx, pointAt(i).dy);
    }

    // Soft gradient fill under the line.
    final Path fillPath = Path.from(linePath)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        // withOpacity is used here (not withValues) on purpose: the pubspec SDK
        // floor is >=3.3.0, and withValues(alpha:) only exists on newer stable
        // SDKs. Newer SDKs may show a deprecation notice for withOpacity; if the
        // floor is bumped past 3.27, switch these two calls to withValues(alpha:).
        // See the minimum SDK note in README.md.
        colors: <Color>[
          lineColor.withOpacity(0.24),
          lineColor.withOpacity(0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final Paint linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.4
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    // A small dot on the latest point.
    final Offset last = pointAt(points.length - 1);
    canvas.drawCircle(last, 3.5, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.lineColor != lineColor;
  }
}
