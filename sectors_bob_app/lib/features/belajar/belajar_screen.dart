import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../services/models/learn_models.dart';
import '../../services/providers.dart';
import 'widgets/article_card.dart';
import 'widgets/video_card.dart';

/// Videos for the Belajar tab.
final FutureProvider<List<LearnVideo>> learnVideosProvider =
    FutureProvider<List<LearnVideo>>((ref) {
  return ref.watch(learnServiceProvider).videos();
});

/// News articles for the Berita segment.
final FutureProvider<List<LearnArticle>> learnArticlesProvider =
    FutureProvider<List<LearnArticle>>((ref) {
  return ref.watch(learnServiceProvider).articles();
});

/// The Belajar (Learn) tab. Replaces the old News tab.
///
/// Two segments: Belajar (educational videos) shown first, and Berita (market
/// news) second. Videos open on YouTube; news is read in place. Both are backed
/// by the mock [LearnService].
class BelajarScreen extends ConsumerStatefulWidget {
  const BelajarScreen({super.key});

  @override
  ConsumerState<BelajarScreen> createState() => _BelajarScreenState();
}

class _BelajarScreenState extends ConsumerState<BelajarScreen> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Belajar',
                    style: text.headlineSmall?.copyWith(
                      color: AppColors.textOnTeal,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Video edukasi dan berita pasar untuk investor.',
                    style: text.bodyMedium
                        ?.copyWith(color: AppColors.textOnTeal2),
                  ),
                  const SizedBox(height: 16),
                  _SegmentToggle(
                    index: _segment,
                    labels: const <String>['Belajar', 'Berita'],
                    onChanged: (int i) => setState(() => _segment = i),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _segment == 0
                  ? const _VideosList()
                  : const _ArticlesList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideosList extends ConsumerWidget {
  const _VideosList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LearnVideo>> videos = ref.watch(learnVideosProvider);
    return videos.when(
      data: (List<LearnVideo> list) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, i) => VideoCard(video: list[i]),
      ),
      loading: () => const _Loading(),
      error: (Object err, StackTrace stack) => const _LoadError(),
    );
  }
}

class _ArticlesList extends ConsumerWidget {
  const _ArticlesList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LearnArticle>> articles =
        ref.watch(learnArticlesProvider);
    return articles.when(
      data: (List<LearnArticle> list) => ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) => ArticleCard(article: list[i]),
      ),
      loading: () => const _Loading(),
      error: (Object err, StackTrace stack) => const _LoadError(),
    );
  }
}

class _SegmentToggle extends StatelessWidget {
  const _SegmentToggle({
    required this.index,
    required this.labels,
    required this.onChanged,
  });

  final int index;
  final List<String> labels;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppColors.radiusPill),
        border: Border.all(color: AppColors.bgSunken),
      ),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: index == i ? AppColors.accent : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppColors.radiusPill),
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      color: index == i
                          ? AppColors.textOnAccent
                          : AppColors.textOnTeal2,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
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

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.accent),
    );
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Gagal memuat konten. Coba lagi nanti.',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.bearish),
      ),
    );
  }
}
