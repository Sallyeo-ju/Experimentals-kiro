import 'package:flutter/material.dart';

import '../../../core/format/formatters.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/signal_badge.dart';
import '../../../services/models/stock_models.dart';

/// A tappable stock row used across Home sections.
///
/// Shows ticker, company name, Rupiah price, and a change badge in data colors.
/// A quick Tanya BOB affordance opens the chat seeded with this ticker. The row
/// itself opens the stock detail.
class StockCard extends StatelessWidget {
  const StockCard({
    super.key,
    required this.stock,
    required this.onTap,
    this.onAskBob,
  });

  final Stock stock;
  final VoidCallback onTap;
  final VoidCallback? onAskBob;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppColors.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppColors.radiusCard),
            border: Border.all(color: AppColors.surfaceLine),
          ),
          child: Row(
            children: <Widget>[
              _TickerAvatar(ticker: stock.ticker),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      stock.ticker,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      stock.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: text.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    Formatters.rupiah(stock.price),
                    style: text.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  SignalBadge.change(
                    changePercent: stock.changePercent,
                    label: Formatters.percent(stock.changePercent),
                  ),
                ],
              ),
              if (onAskBob != null) ...<Widget>[
                const SizedBox(width: 4),
                IconButton(
                  onPressed: onAskBob,
                  tooltip: 'Tanya BOB soal ${stock.ticker}',
                  visualDensity: VisualDensity.compact,
                  icon: const Icon(
                    Icons.auto_awesome_outlined,
                    color: AppColors.accentPress,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// A small rounded square holding the first letters of the ticker.
class _TickerAvatar extends StatelessWidget {
  const _TickerAvatar({required this.ticker});

  final String ticker;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      width: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.bgBase,
        borderRadius: BorderRadius.circular(AppColors.radiusSmall),
      ),
      child: Text(
        ticker.length >= 2 ? ticker.substring(0, 2) : ticker,
        style: const TextStyle(
          color: AppColors.textOnTeal,
          fontWeight: FontWeight.w800,
          fontSize: 15,
        ),
      ),
    );
  }
}
