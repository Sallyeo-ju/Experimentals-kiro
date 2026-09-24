import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/signal_badge.dart';
import '../../services/models/analysis_models.dart';

/// A small mock news item for the placeholder feed.
class _NewsItem {
  const _NewsItem(this.title, this.source, this.sentiment);
  final String title;
  final String source;
  final Sentiment sentiment;
}

/// The News (Berita) tab.
///
/// A light, intentionally minimal placeholder: a title, a short Segera hadir
/// note, and a few static news items with sentiment badges so the tab is not
/// empty while the full feed is built later.
class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  static const List<_NewsItem> _items = <_NewsItem>[
    _NewsItem(
      'IHSG ditutup menguat tipis ditopang saham perbankan',
      'Kontan',
      Sentiment.positif,
    ),
    _NewsItem(
      'Investor mencermati rilis data inflasi bulan ini',
      'Bisnis Indonesia',
      Sentiment.netral,
    ),
    _NewsItem(
      'Tekanan nilai tukar rupiah membayangi sesi perdagangan',
      'CNBC Indonesia',
      Sentiment.negatif,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          children: <Widget>[
            Text(
              'Berita',
              style: text.headlineSmall?.copyWith(
                color: AppColors.textOnTeal,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Segera hadir. Sementara ini, berikut beberapa sorotan pasar.',
              style: text.bodyMedium?.copyWith(color: AppColors.textOnTeal2),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < _items.length; i++) ...<Widget>[
              _NewsCard(item: _items[i]),
              if (i != _items.length - 1) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item});

  final _NewsItem item;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.surfaceLine),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            item.title,
            style: text.bodyLarge?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              Text(
                item.source,
                style: text.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SignalBadge.sentiment(item.sentiment),
            ],
          ),
        ],
      ),
    );
  }
}
