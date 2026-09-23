import 'package:flutter/material.dart';

import '../../services/models/analysis_models.dart';
import '../theme/app_colors.dart';

/// A pill badge for DATA signals only.
///
/// Maps a [Signal] or [Sentiment] to soft background and data-colored text
/// (green for bullish/positive, red for bearish/negative, muted for neutral).
/// These colors are for data and must never appear on action buttons.
class SignalBadge extends StatelessWidget {
  const SignalBadge._({
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
  });

  /// Builds a badge from an analysis [Signal].
  factory SignalBadge.signal(Signal signal, {String? label}) {
    switch (signal) {
      case Signal.bullish:
        return SignalBadge._(
          label: label ?? 'Bullish',
          background: AppColors.bullishSoft,
          foreground: AppColors.bullish,
          icon: Icons.trending_up,
        );
      case Signal.bearish:
        return SignalBadge._(
          label: label ?? 'Bearish',
          background: AppColors.bearishSoft,
          foreground: AppColors.bearish,
          icon: Icons.trending_down,
        );
      case Signal.netral:
        return SignalBadge._(
          label: label ?? 'Netral',
          background: AppColors.surfaceAlt,
          foreground: AppColors.textSecondary,
          icon: Icons.trending_flat,
        );
    }
  }

  /// Builds a badge from a news [Sentiment].
  factory SignalBadge.sentiment(Sentiment sentiment) {
    switch (sentiment) {
      case Sentiment.positif:
        return const SignalBadge._(
          label: 'Positif',
          background: AppColors.bullishSoft,
          foreground: AppColors.bullish,
        );
      case Sentiment.negatif:
        return const SignalBadge._(
          label: 'Negatif',
          background: AppColors.bearishSoft,
          foreground: AppColors.bearish,
        );
      case Sentiment.netral:
        return const SignalBadge._(
          label: 'Netral',
          background: AppColors.surfaceAlt,
          foreground: AppColors.textSecondary,
        );
    }
  }

  /// Builds a badge for a percent change value. Positive reads bullish, negative
  /// reads bearish. This shows data only, never an instruction.
  factory SignalBadge.change({
    required double changePercent,
    required String label,
  }) {
    if (changePercent > 0) {
      return SignalBadge._(
        label: label,
        background: AppColors.bullishSoft,
        foreground: AppColors.bullish,
        icon: Icons.arrow_drop_up,
      );
    }
    if (changePercent < 0) {
      return SignalBadge._(
        label: label,
        background: AppColors.bearishSoft,
        foreground: AppColors.bearish,
        icon: Icons.arrow_drop_down,
      );
    }
    return SignalBadge._(
      label: label,
      background: AppColors.surfaceAlt,
      foreground: AppColors.textSecondary,
    );
  }

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppColors.radiusPill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 14, color: foreground),
            const SizedBox(width: 2),
          ],
          Text(
            label,
            style: TextStyle(
              color: foreground,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
