import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/format/formatters.dart';
import '../../core/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/signal_badge.dart';
import '../../services/models/stock_models.dart';
import 'home_providers.dart';
import 'widgets/stock_card.dart';

/// Suggested questions shown in the ask-BOB area. Natural, everyday phrasing.
const List<String> _suggestedQuestions = <String>[
  'Bagaimana BBCA hari ini?',
  'Bandingkan BBRI dan BMRI',
  'Saham bank mana yang menarik?',
];

/// The Home (Beranda) hero screen.
///
/// Teal canvas with an ask-BOB entry bar, suggested questions, a portfolio
/// summary, and lists of local stocks, favorites, and recent history sourced
/// from the mock stock service.
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _ask = TextEditingController();

  @override
  void dispose() {
    _ask.dispose();
    super.dispose();
  }

  void _openChat({String? seed, String? ticker}) {
    context.go(AppRoutes.aiWith(seed: seed, ticker: ticker));
  }

  void _submitAsk() {
    final String text = _ask.text.trim();
    _openChat(seed: text.isEmpty ? null : text);
  }

  void _openStock(String ticker) => context.push(AppRoutes.stock(ticker));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(child: _buildHeader(context)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              sliver: SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  const _PortfolioCard(),
                  const SizedBox(height: 24),
                  _StockSection(
                    title: 'Saham Lokal',
                    provider: localStocksProvider,
                    onOpenStock: _openStock,
                    onAskBob: (String t) => _openChat(ticker: t),
                  ),
                  const SizedBox(height: 24),
                  _StockSection(
                    title: 'Favorit dan Paling Dicari',
                    provider: favoritesProvider,
                    onOpenStock: _openStock,
                    onAskBob: (String t) => _openChat(ticker: t),
                  ),
                  const SizedBox(height: 24),
                  _StockSection(
                    title: 'Riwayat Terakhir',
                    provider: recentlySearchedProvider,
                    onOpenStock: _openStock,
                    onAskBob: (String t) => _openChat(ticker: t),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Halo, investor',
            style: text.bodyMedium?.copyWith(color: AppColors.textOnTeal2),
          ),
          const SizedBox(height: 2),
          Text(
            'Mau tanya saham apa hari ini?',
            style: text.headlineSmall?.copyWith(
              color: AppColors.textOnTeal,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          _AskBar(controller: _ask, onSubmit: _submitAsk),
          const SizedBox(height: 12),
          _SuggestedQuestions(
            onSelected: (String q) => _openChat(seed: q),
          ),
        ],
      ),
    );
  }
}

/// The pinned ask-BOB field. Tapping the send affordance opens the chat, passing
/// along whatever the user typed.
class _AskBar extends StatelessWidget {
  const _AskBar({required this.controller, required this.onSubmit});

  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppColors.radiusPill),
        border: Border.all(color: AppColors.surfaceLine),
      ),
      child: Row(
        children: <Widget>[
          const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSubmit(),
              decoration: const InputDecoration(
                hintText: 'Tanya BOB soal saham apa saja',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Material(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(AppColors.radiusPill),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppColors.radiusPill),
                onTap: onSubmit,
                child: const Padding(
                  padding: EdgeInsets.all(9),
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColors.textOnAccent,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold-outline suggestion chips shown below the ask bar.
class _SuggestedQuestions extends StatelessWidget {
  const _SuggestedQuestions({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _suggestedQuestions.map((String q) {
        return InkWell(
          borderRadius: BorderRadius.circular(AppColors.radiusPill),
          onTap: () => onSelected(q),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppColors.radiusPill),
              border: Border.all(color: AppColors.accent),
            ),
            child: Text(
              q,
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// The Portofolio Saya summary card. Mock totals rendered with data colors.
class _PortfolioCard extends StatelessWidget {
  const _PortfolioCard();

  static const double _totalValue = 24850000;
  static const double _dayChangePercent = 0.86;
  static const double _dayChangeValue = 212000;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppColors.radiusCard),
        border: Border.all(color: AppColors.bgSunken),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Portofolio Saya',
            style: text.titleSmall?.copyWith(color: AppColors.textOnTeal2),
          ),
          const SizedBox(height: 8),
          Text(
            Formatters.rupiah(_totalValue),
            style: text.headlineMedium?.copyWith(
              color: AppColors.textOnTeal,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              SignalBadge.change(
                changePercent: _dayChangePercent,
                label: Formatters.percent(_dayChangePercent),
              ),
              const SizedBox(width: 8),
              Text(
                '${Formatters.signedRupiah(_dayChangeValue)} hari ini',
                style: text.bodySmall?.copyWith(color: AppColors.textOnTeal2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A titled section that renders an async list of stocks with loading and error
/// states.
class _StockSection extends ConsumerWidget {
  const _StockSection({
    required this.title,
    required this.provider,
    required this.onOpenStock,
    required this.onAskBob,
  });

  final String title;
  final FutureProvider<List<Stock>> provider;
  final ValueChanged<String> onOpenStock;
  final ValueChanged<String> onAskBob;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Stock>> stocks = ref.watch(provider);
    final TextTheme text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: text.titleMedium?.copyWith(
            color: AppColors.textOnTeal,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 12),
        stocks.when(
          data: (List<Stock> list) {
            if (list.isEmpty) {
              return Text(
                'Belum ada data.',
                style: text.bodyMedium?.copyWith(color: AppColors.textOnTeal2),
              );
            }
            return Column(
              children: <Widget>[
                for (int i = 0; i < list.length; i++) ...<Widget>[
                  StockCard(
                    stock: list[i],
                    onTap: () => onOpenStock(list[i].ticker),
                    onAskBob: () => onAskBob(list[i].ticker),
                  ),
                  if (i != list.length - 1) const SizedBox(height: 10),
                ],
              ],
            );
          },
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            ),
          ),
          error: (Object err, StackTrace stack) => Text(
            'Gagal memuat data. Coba lagi nanti.',
            style: text.bodyMedium?.copyWith(color: AppColors.bearish),
          ),
        ),
      ],
    );
  }
}
