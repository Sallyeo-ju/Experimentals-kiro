import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../services/models/learn_models.dart';
import 'belajar_screen.dart';

/// In-app reader for a market news article, opened from the Belajar feed.
///
/// Mirrors the reference detail layout: an image header with a source badge, an
/// inert Comment / Like / Share action row (no backend), then the headline,
/// meta, and full body paragraphs. The article is looked up by id so navigation
/// can pass just the id.
class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({super.key, required this.articleId});

  final String articleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<LearnArticle>> articles =
        ref.watch(learnArticlesProvider);
    return Scaffold(
      backgroundColor: AppColors.bgBase,
      appBar: AppBar(
        backgroundColor: AppColors.bgBase,
        foregroundColor: AppColors.textOnTeal,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Disimpan ke bookmark.')),
              );
            },
            tooltip: 'Simpan',
            icon: const Icon(Icons.bookmark_border),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: articles.when(
        data: (List<LearnArticle> list) {
          final LearnArticle? article = _find(list);
          if (article == null) {
            return const _NotFound();
          }
          return _Body(article: article);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (Object err, StackTrace stack) => const _NotFound(),
      ),
    );
  }

  LearnArticle? _find(List<LearnArticle> list) {
    for (final LearnArticle a in list) {
      if (a.id == articleId) {
        return a;
      }
    }
    return null;
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.article});

  final LearnArticle article;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
      children: <Widget>[
        _ImageHeader(source: article.source),
        const SizedBox(height: 12),
        const _ActionRow(),
        const SizedBox(height: 20),
        Text(
          article.title,
          style: text.headlineSmall?.copyWith(
            color: AppColors.textOnTeal,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Text(
              article.source,
              style: text.bodySmall?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.circle, size: 4, color: AppColors.textOnTeal2),
            const SizedBox(width: 8),
            Text(
              article.timeAgo,
              style: text.bodySmall?.copyWith(color: AppColors.textOnTeal2),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.circle, size: 4, color: AppColors.textOnTeal2),
            const SizedBox(width: 8),
            Text(
              article.readTime,
              style: text.bodySmall?.copyWith(color: AppColors.textOnTeal2),
            ),
          ],
        ),
        const SizedBox(height: 18),
        for (final String paragraph in article.body) ...<Widget>[
          Text(
            paragraph,
            style: text.bodyLarge?.copyWith(
              color: AppColors.textOnTeal,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
        ],
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.bgElevated,
            borderRadius: BorderRadius.circular(AppColors.radiusSmall),
            border: Border.all(color: AppColors.bgSunken),
          ),
          child: Text(
            'Berita ini bersifat informasi umum dan bukan rekomendasi beli '
            'atau jual. Lakukan riset mandiri sebelum berinvestasi.',
            style: text.bodySmall?.copyWith(color: AppColors.textOnTeal2),
          ),
        ),
      ],
    );
  }
}

class _ImageHeader extends StatelessWidget {
  const _ImageHeader({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppColors.radiusCard),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            const ColoredBox(
              color: AppColors.bgElevated,
              child: Center(
                child: Icon(
                  Icons.image_outlined,
                  color: AppColors.textOnTeal2,
                  size: 40,
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.transparent, Color(0x66000000)],
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppColors.radiusPill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Icon(
                      Icons.newspaper,
                      size: 14,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      source,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The inert Comment / Like / Share row. These are display-only in the mock and
/// show a short note when tapped rather than performing an action.
class _ActionRow extends StatelessWidget {
  const _ActionRow();

  void _note(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fitur ini belum aktif pada versi ini.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.bgElevated,
        borderRadius: BorderRadius.circular(AppColors.radiusPill),
        border: Border.all(color: AppColors.bgSunken),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _ActionItem(
            icon: Icons.mode_comment_outlined,
            label: 'Komentar',
            onTap: () => _note(context),
          ),
          _ActionItem(
            icon: Icons.favorite_border,
            label: 'Suka',
            onTap: () => _note(context),
          ),
          _ActionItem(
            icon: Icons.share_outlined,
            label: 'Bagikan',
            onTap: () => _note(context),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textOnTeal,
      ),
      icon: Icon(icon, size: 18, color: AppColors.textOnTeal),
      label: Text(
        label,
        style: const TextStyle(
          color: AppColors.textOnTeal,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Artikel tidak ditemukan.',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.textOnTeal2),
      ),
    );
  }
}
